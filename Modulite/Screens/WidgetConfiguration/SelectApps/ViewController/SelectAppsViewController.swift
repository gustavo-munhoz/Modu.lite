//
//  SelectAppsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit

class SelectAppsViewController: UIViewController {
    
    // MARK: - Properties
    private let selectAppsView = SelectAppsView()
    private let viewModel = SelectAppsViewModel()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = selectAppsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        selectAppsView.setCollectionViewDelegate(to: self)
        selectAppsView.setCollectionViewDataSource(to: self)
    }
}

// MARK: - UICollectionViewDelegate
extension SelectAppsViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AppCollectionViewCell.reuseId,
            for: indexPath
        ) as? AppCollectionViewCell else {
            fatalError("Unable to dequeue AppCollectionViewCell")
        }
        
        cell.backgroundColor = .charcoalGray.withAlphaComponent(0.3)
    }
}

// MARK: - UICollectionViewDataSource
extension SelectAppsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.apps.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AppCollectionViewCell.reuseId,
            for: indexPath
        ) as? AppCollectionViewCell else {
            fatalError("Unable to dequeue AppCollectionViewCell")
        }
        
        cell.setup(with: viewModel.apps[indexPath.row])
        
        return cell
    }
}
