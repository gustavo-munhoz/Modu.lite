//
//  HomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit
import WidgetStyling
import Combine

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewControllerDidStartWidgetCreationFlow(
        _ viewController: HomeViewController,
        type: WidgetType
    )
    
    func homeViewControllerDidStartWidgetEditingFlow(
        _ viewController: HomeViewController,
        widget: WidgetSchema
    )
    
    func homeViewControllerDidFinishOnboarding(
        _ viewController: HomeViewController
    )
    
    func homeViewController(
        _ viewController: HomeViewController,
        shouldPresentOfferPlus: Bool
    )
}

class HomeViewController: UIViewController {

    // MARK: - Properties
    private(set) var homeView = HomeView()
    private(set) var viewModel = HomeViewModel()
    
    weak var delegate: HomeViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = homeView
        homeView.setCollectionViewDelegates(to: self)
        homeView.setCollectionViewDataSources(to: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        updatePlaceholderViews()
        setupOnboardingObserverIfNeeded()
        setupSubscriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkIfDidShouldPresentPlus()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .widgetEditorDidFinishOnboarding,
            object: nil
        )
    }
    
    // MARK: - Setup methods
    private func setupSubscriptions() {
        SubscriptionManager.shared.$activeSubscription
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.homeView.mainWidgetsCollectionView.reloadData()
                self.homeView.auxiliaryWidgetsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Modu.lite"
        navigationItem.titleView = UIView()
        navigationController?.navigationBar.barTintColor = .whiteTurnip
    }
    
    private func setupOnboardingObserverIfNeeded() {
        if !UserPreference<Onboarding>.shared.bool(for: .hasCompletedOnboarding) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleOnboardingCompletion),
                name: .widgetEditorDidFinishOnboarding,
                object: nil
            )
        }
    }
    
    // MARK: - Actions
    private func checkIfDidShouldPresentPlus() {
        let spec = HasCompletedOnboardingSpecification()
                       .and(DidOpenWithEventSpecification())
        
        delegate?.homeViewController(
            self,
            shouldPresentOfferPlus: spec.isSatisfied()
        )
        
        UserDefaults.standard.set(false, forKey: "shouldPresentOfferPlus")
    }
    
    @objc private func handleOnboardingCompletion() {
        delegate?.homeViewControllerDidFinishOnboarding(self)
        
        viewModel = HomeViewModel()
        homeView.setMainWidgetPlaceholderVisibility(to: false)
        homeView.mainWidgetsCollectionView.reloadData()
    }
    
    @MainActor func updatePlaceholderViews() {
        if IsPlusSubscriberSpecification().isSatisfied() {
            homeView.setAuxWidgetPlaceholderToPlusVersion()
        }
        
        homeView.setMainWidgetPlaceholderVisibility(to: viewModel.mainWidgets.isEmpty)
        homeView.setAuxWidgetPlaceholderVisibility(to: viewModel.auxiliaryWidgets.isEmpty)
    }
    
    func getCurrentWidgetCount(for type: WidgetType) -> Int {
        switch type {
        case .main:
            return viewModel.mainWidgets.count
        case .auxiliary:
            return viewModel.auxiliaryWidgets.count
        @unknown default:
            fatalError("Invalid widget type")
        }
    }
    
    func updateWidget(_ widget: WidgetSchema, type: WidgetType) {
        viewModel.updateWidget(widget, type: type)
        
        guard let index = viewModel.getIndexFor(widget, type: type) else {
            print("Widget not found in data source.")
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        let collectionView = getCollectionView(for: type)
        
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func registerNewWidget(_ widget: WidgetSchema, type: WidgetType) {
        viewModel.addWidget(widget, type: type)
        
        guard let index = viewModel.getIndexFor(widget, type: type) else {
            print("Widget not found in data source.")
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        let collectionView = getCollectionView(for: type)
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [indexPath])
        } completion: { _ in
            let indexSet = IndexSet(integer: 0)
            collectionView.reloadSections(indexSet)
        }
        
        updatePlaceholderViews()
    }
    
    func deleteWidget(_ widget: WidgetSchema, type: WidgetType) {
        guard let index = viewModel.getIndexFor(widget, type: type) else {
            print("Widget not found in data source.")
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        let collectionView = getCollectionView(for: type)
        
        viewModel.deleteWidget(widget, type: type)
        
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [indexPath])
        } completion: { _ in
            let indexSet = IndexSet(integer: 0)
            collectionView.reloadSections(indexSet)
        }
        
        updatePlaceholderViews()
    }
    
    // MARK: - Helper Methods
    
    private func getCollectionView(for type: WidgetType) -> UICollectionView {
        switch type {
        case .main:
            return homeView.mainWidgetsCollectionView
        case .auxiliary:
            return homeView.auxiliaryWidgetsCollectionView
        @unknown default:
            fatalError("Invalid widget type")
        }
    }
    
    private func widgetType(for collectionView: UICollectionView) -> WidgetType? {
        if collectionView == homeView.mainWidgetsCollectionView {
            return .main
        } else if collectionView == homeView.auxiliaryWidgetsCollectionView {
            return .auxiliary
        } else {
            return nil
        }
    }
}

extension HomeViewController {
    class func instantiate(delegate: HomeViewControllerDelegate) -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.delegate = delegate
        return homeVC
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case homeView.mainWidgetsCollectionView: return viewModel.mainWidgets.count
        case homeView.auxiliaryWidgetsCollectionView: return viewModel.auxiliaryWidgets.count
        case homeView.tipsCollectionView: return viewModel.tips.count
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
        case homeView.mainWidgetsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeWidgetCollectionViewCell.reuseId,
                    for: indexPath
                  ) as? HomeWidgetCollectionViewCell else {
                fatalError("Could not dequeue MainWidgetCollectionViewCell.")
            }
            
            let schema = viewModel.mainWidgets[indexPath.row]
            cell.configure(image: schema.previewImage, name: schema.name)
            cell.delegate = self
            
            return cell
            
        case homeView.auxiliaryWidgetsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeWidgetCollectionViewCell.reuseId,
                for: indexPath
            ) as? HomeWidgetCollectionViewCell else {
                fatalError("Could not dequeue AuxiliaryWidgetCollectionViewCell.")
            }
            
            let schema = viewModel.auxiliaryWidgets[indexPath.row]
            
            cell.configure(image: schema.previewImage, name: schema.name)
            cell.delegate = self
            
            if !IsPlusSubscriberSpecification().isSatisfied() {
                cell.disableInteraction()
            } else {
                cell.enableInteraction()
            }
            
            return cell
            
        case homeView.tipsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TipCollectionViewCell.reuseId,
                for: indexPath
            ) as? TipCollectionViewCell else {
                fatalError("Could not dequeue TipCollectionViewCell.")
            }
            
            return cell
            
        default:
            fatalError("Unsupported collection view.")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = dequeueHeader(
            for: collectionView,
            kind: kind,
            indexPath: indexPath
        ) else {
            fatalError("Error dequeueing Header cell.")
        }

        configureHeader(header, for: collectionView)

        return header
    }

    private func dequeueHeader(
        for collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> HomeHeaderReusableCell? {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HomeHeaderReusableCell.reuseId,
            for: indexPath
        ) as? HomeHeaderReusableCell
    }

    private func configureHeader(
        _ header: HomeHeaderReusableCell,
        for collectionView: UICollectionView
    ) {
        switch collectionView {
        case homeView.mainWidgetsCollectionView:
            configureMainWidgetsHeader(header)

        case homeView.auxiliaryWidgetsCollectionView:
            configureAuxiliaryWidgetsHeader(header)

        case homeView.tipsCollectionView:
            configureTipsHeader(header)

        default:
            fatalError("Unsupported collection view.")
        }
    }

    private func configureMainWidgetsHeader(_ header: HomeHeaderReusableCell) {
        let countValues: (Int, Int)? = {
            if !IsPlusSubscriberSpecification().isSatisfied() {
                return (current: viewModel.mainWidgets.count, max: 3)
            }
            return nil
        }()

        header.setup(
            title: .localized(for: .homeViewMainSectionHeaderTitle),
            buttonImage: UIImage(systemName: "plus.circle")!,
            buttonAction: { [weak self] in
                guard let self = self else { return }
                self.delegate?.homeViewControllerDidStartWidgetCreationFlow(
                    self,
                    type: .main
                )
            },
            countValues: countValues
        )

        if let countValues = countValues {
            header.updateCurrentCount(to: countValues.0)
        }
    }

    private func configureAuxiliaryWidgetsHeader(_ header: HomeHeaderReusableCell) {
        header.setup(
            title: .localized(for: .homeViewAuxiliarySectionHeaderTitle),
            buttonImage: UIImage(systemName: "plus.circle")!,
            buttonAction: { [weak self] in
                guard let self = self else { return }
                self.delegate?.homeViewControllerDidStartWidgetCreationFlow(
                    self,
                    type: .auxiliary
                )
            },
            isPlusExclusive: true
        )
    }

    private func configureTipsHeader(_ header: HomeHeaderReusableCell) {
        header.setup(
            title: .localized(for: .homeViewTipsSectionHeaderTitle)
        )
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case homeView.mainWidgetsCollectionView:
            delegate?.homeViewControllerDidStartWidgetEditingFlow(
                self,
                widget: viewModel.mainWidgets[indexPath.row]
            )
            
        case homeView.auxiliaryWidgetsCollectionView:
            delegate?.homeViewControllerDidStartWidgetEditingFlow(
                self,
                widget: viewModel.auxiliaryWidgets[indexPath.row]
            )
            
        default:
            return
        }
    }
}
