//
//  HomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    let homeView = HomeView()
    var viewModel: HomeViewModel?
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = homeView
        homeView.setCollectionViewDelegates(to: self)
        homeView.setCollectionViewDataSources(to: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViewModel()
        setupNavigationBar()
        
    }
    
    // MARK: - Setup methods
    private func setupViewModel() {
        self.viewModel = HomeViewModel()
    }
    
    private func setupNavigationBar() {
        // FIXME: Make image be on bottom-left of navbar with large title
        
        if let image = UIImage(named: "navbar-app-name") {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            navigationItem.titleView = imageView
            
        } else {
            print("Image not found")
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        
        switch collectionView {
        case homeView.mainWidgetsCollectionView: return viewModel.mainWidgets.count
        case homeView.auxiliaryWidgetsCollectionView: return viewModel.auxiliaryWidgets.count
        case homeView.tipsCollectionView: return viewModel.tips.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case homeView.mainWidgetsCollectionView:
            guard let viewModel = viewModel,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainWidgetCollectionViewCell.reuseId,
                    for: indexPath
                  ) as? MainWidgetCollectionViewCell else {
                fatalError("Could not dequeue MainWidgetCollectionViewCell.")
            }
            
            cell.configure(with: viewModel.mainWidgets[indexPath.row])
            
            return cell
            
        case homeView.auxiliaryWidgetsCollectionView:
            guard let viewModel = viewModel,
                  let cell = collectionView.dequeueReusableCell(
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderReusableCell.reuseId,
            for: indexPath
        ) as? HeaderReusableCell else {
            fatalError("Error dequeueing Header cell.")
        }
        
        header.setup(
            title: getHeaderText(for: collectionView),
            buttonImage: collectionView === homeView.tipsCollectionView ? UIImage(systemName: "ellipsis")! : UIImage(systemName: "plus.circle")!,
            buttonColor: collectionView === homeView.tipsCollectionView ? .systemGray : .turquoise,
            buttonAction: {
                // TODO: Implement actions
            }
        )
        
        return header
    }
    
    private func getHeaderText(for collectionView: UICollectionView) -> String {
        switch collectionView {
        case homeView.mainWidgetsCollectionView: return .localized(for: .homeViewMainSectionHeaderTitle)
        case homeView.auxiliaryWidgetsCollectionView: return .localized(for: .homeViewAuxiliarySectionHeaderTitle)
        case homeView.tipsCollectionView: return .localized(for: .homeViewTipsSectionHeaderTitle)
        default: return ""
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    // TODO: Implement this
}
