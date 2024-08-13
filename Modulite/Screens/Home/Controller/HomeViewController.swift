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
        // FIXME: Make image be on bottom-left of navbar with large title
        
        setupViewModel()
        setupNavigationBar()
        
    }
    
    // MARK: - Setup methods
    private func setupViewModel() {
        self.viewModel = HomeViewModel()
    }
    
    private func setupNavigationBar() {
        if let image = UIImage(named: "navbar-app-name") {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit

            imageView.frame = CGRect(x: 0, y: 0, width: 226, height: 32)
            
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
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AuxiliaryWidgetCollectionViewCell.reuseId,
                for: indexPath
            ) as? AuxiliaryWidgetCollectionViewCell else {
                fatalError("Could not dequeue AuxiliaryWidgetCollectionViewCell.")
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
        
        header.setup(title: getHeaderText(for: collectionView))
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case homeView.mainWidgetsCollectionView: return CGSize(width: 192, height: 235)
        case homeView.auxiliaryWidgetsCollectionView: return CGSize(width: 192, height: 130)
        case homeView.tipsCollectionView: return CGSize(width: 200, height: 150)        
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
