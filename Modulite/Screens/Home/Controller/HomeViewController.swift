//
//  HomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

class HomeViewController: UIViewController {

    let homeView = HomeView()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // FIXME: Get cells from ViewModel.
        switch section {
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainWidgetCollectionViewCell.reuseId,
                for: indexPath
            ) as? MainWidgetCollectionViewCell else {
                fatalError("Error dequeueing MainWidget cell.")
            }
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AuxiliaryWidgetCollectionViewCell.reuseId,
                for: indexPath
            ) as? AuxiliaryWidgetCollectionViewCell else {
                fatalError("Error dequeueing AuxiliaryWidget cell.")
            }
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TipCollectionViewCell.reuseId,
                for: indexPath
            ) as? TipCollectionViewCell else {
                fatalError("Error dequeueing Tip cell.")
            }
            return cell
            
        default:
            fatalError("Unexpected Section.")
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
        
        header.titleLabel.text = getHeaderText(for: indexPath)
        return header
    }
    
    private func getHeaderText(for indexPath: IndexPath) -> String {
        return [
            String.localized(for: .homeViewMainSectionHeaderTitle),
            String.localized(for: .homeViewAuxiliarySectionHeaderTitle),
            String.localized(for: .homeViewTipsSectionHeaderTitle),
        ][indexPath.row]
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: 192, height: 235)
        case 1: return CGSize(width: 192, height: 130)
        case 2: return CGSize(width: 200, height: 150)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
