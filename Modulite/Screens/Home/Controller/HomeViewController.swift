//
//  HomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    
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
    func setViewModelNavigationDelegate(to delegate: HomeNavigationFlowDelegate) {
        viewModel.delegate = delegate
    }
    
    private func setupNavigationBar() {
        // FIXME: Make image be on bottom-left of navbar with large title
            
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.whiteTurnip
                
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if let image = UIImage(named: "navbar-app-name") {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            navigationItem.titleView = imageView
            
        } else {
            print("Image not found")
        }
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
            
            cell.configure(with: viewModel.mainWidgets[indexPath.row])
            
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
                    self.viewModel.startWidgetSetupFlow()
                }
            )
            
        case homeView.auxiliaryWidgetsCollectionView:
            header.setup(
                title: .localized(for: .homeViewAuxiliarySectionHeaderTitle),
                buttonImage: UIImage(systemName: "plus.circle")!,
                buttonAction: { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.startWidgetSetupFlow()
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
    // TODO: Implement this
}
