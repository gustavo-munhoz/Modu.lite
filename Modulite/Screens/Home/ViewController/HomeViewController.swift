//
//  HomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewControllerDidStartWidgetCreationFlow(
        _ viewController: HomeViewController
    )
    
    func homeViewControllerDidStartWidgetEditingFlow(
        _ viewController: HomeViewController,
        widget: ModuliteWidgetConfiguration
    )
}

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    
    weak var delegate: HomeViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = homeView
        homeView.setCollectionViewDelegates(to: self)
        homeView.setCollectionViewDataSources(to: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    // MARK: - Setup methods
    private func setupNavigationBar() {
        // FIXME: Make image be on bottom-left of navbar with large title
            
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.whiteTurnip
                
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        guard let image = UIImage(named: "navbar-app-name") else {
            print("Image not found")
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    // MARK: - Actions
    func getCurrentMainWidgetCount() -> Int {
        viewModel.mainWidgets.count
    }
    
    func updateMainWidget(_ widget: ModuliteWidgetConfiguration) {
        viewModel.updateMainWidget(widget)
        
        guard let index = viewModel.getIndexFor(widget) else {
            print("Widget not found in data source.")
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        
        homeView.mainWidgetsCollectionView.performBatchUpdates { [weak self] in
            self?.homeView.mainWidgetsCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func registerNewWidget(_ widget: ModuliteWidgetConfiguration) {
        viewModel.addMainWidget(widget)
        
        guard let index = viewModel.getIndexFor(widget) else {
            print("Widget not found in data source.")
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        
        homeView.mainWidgetsCollectionView.performBatchUpdates { [weak self] in
            self?.homeView.mainWidgetsCollectionView.insertItems(at: [indexPath])
        }
    }
    
    func deleteWidget(_ widget: ModuliteWidgetConfiguration) {
        guard let index = viewModel.getIndexFor(widget) else {
            print("Widget not found in data source.")
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        
        viewModel.deleteMainWidget(widget)
        homeView.mainWidgetsCollectionView.performBatchUpdates { [weak self] in
            self?.homeView.mainWidgetsCollectionView.deleteItems(at: [indexPath])
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
                    withReuseIdentifier: MainWidgetCollectionViewCell.reuseId,
                    for: indexPath
                  ) as? MainWidgetCollectionViewCell else {
                fatalError("Could not dequeue MainWidgetCollectionViewCell.")
            }
            
            let widget = viewModel.mainWidgets[indexPath.row]
            cell.configure(image: widget.previewImage, name: widget.name)
            cell.delegate = self
            
            return cell
            
        case homeView.auxiliaryWidgetsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AuxiliaryWidgetCollectionViewCell.reuseId,
                for: indexPath
            ) as? AuxiliaryWidgetCollectionViewCell else {
                fatalError("Could not dequeue AuxiliaryWidgetCollectionViewCell.")
            }
            
            cell.configure(with: viewModel.auxiliaryWidgets[indexPath.row])
            
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
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HomeHeaderReusableCell.reuseId,
            for: indexPath
        ) as? HomeHeaderReusableCell else {
            fatalError("Error dequeueing Header cell.")
        }
        
        switch collectionView {
        case homeView.mainWidgetsCollectionView:
            header.setup(
                title: .localized(for: .homeViewMainSectionHeaderTitle),
                buttonImage: UIImage(systemName: "plus.circle")!,
                buttonAction: { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.homeViewControllerDidStartWidgetCreationFlow(self)
                }
            )
            
        case homeView.auxiliaryWidgetsCollectionView:
            header.setup(
                title: .localized(for: .homeViewAuxiliarySectionHeaderTitle),
                buttonImage: UIImage(systemName: "plus.circle")!,
                buttonAction: { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.homeViewControllerDidStartWidgetCreationFlow(self)
                }
            )
            
        case homeView.tipsCollectionView:
            header.setup(
                title: .localized(for: .homeViewTipsSectionHeaderTitle),
                buttonImage: UIImage(systemName: "ellipsis")!,
                buttonColor: .systemGray,
                buttonAction: {
                    // TODO: Implement this
                }
            )
            
        default: fatalError("Unsupported collection view.")
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    // TODO: Implement cell selection
    
}

// MARK: - MainWidgetCollectionViewCellDelegate
extension HomeViewController: MainWidgetCollectionViewCellDelegate {
    func mainWidgetCellDidRequestEdit(_ cell: MainWidgetCollectionViewCell) {
        guard let indexPath = homeView.mainWidgetsCollectionView.indexPath(for: cell) else {
            print("Could not find index path for cell.")
            return
        }
        
        let widget = viewModel.mainWidgets[indexPath.row]
        delegate?.homeViewControllerDidStartWidgetEditingFlow(self, widget: widget)
    }
    
    func mainWidgetCellDidRequestDelete(_ cell: MainWidgetCollectionViewCell) {
        guard let indexPath = homeView.mainWidgetsCollectionView.indexPath(for: cell) else {
            print("Could not find index path for cell.")
            return
        }
        
        presentWidgetDeletionWarning(for: cell, in: indexPath)
    }
    
    private func presentWidgetDeletionWarning(
        for cell: MainWidgetCollectionViewCell,
        in indexPath: IndexPath
    ) {
        let alert = UIAlertController(
            title: .localized(
                for: .homeViewDeleteWidgetAlertTitle(widgetName: cell.widgetName)
            ),
            message: .localized(for: .homeViewDeleteWidgetAlertMessage),
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(
            title: .localized(for: .delete),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            
            let widget = self.viewModel.mainWidgets[indexPath.row]
            self.deleteWidget(widget)
        }
        
        let cancelAction = UIAlertAction(
            title: .localized(for: .cancel),
            style: .cancel
        )
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}
