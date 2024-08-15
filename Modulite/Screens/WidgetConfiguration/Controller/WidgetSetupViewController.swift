//
//  WidgetSetupViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetSetupViewController: UIViewController {
    
    private let setupView = WidgetSetupView()
    private let viewModel = WidgetSetupViewModel()
    
    override func loadView() {
        view = setupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView.setCollectionViewDelegates(to: self)
        setupView.setCollectionViewDataSources(to: self)
    }
}

// MARK: - UICollectionViewDataSource
extension WidgetSetupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.widgetStyles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StyleCollectionViewCell.reuseId,
            for: indexPath
        ) as? StyleCollectionViewCell else {
            fatalError("Could not dequeue StyleCollectionViewCell")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SetupHeaderReusableCell.reuseId,
            for: indexPath
        ) as? SetupHeaderReusableCell else {
            fatalError("Could not dequeue SetupHeader cell.")
        }
        
        header.setup(title: "Select widget style")
        
        return header
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension WidgetSetupViewController: UICollectionViewDelegate {
    
}

