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
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        viewModel.shouldSelectItem(at: indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        viewModel.isAppSelected(at: indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        updateAndAnimateCollectionView(collectionView, for: indexPath)
        selectAppsView.updateAppCountText(to: viewModel.getSelectedAppsCount())
        
        if viewModel.didReachMaxNumberOfApps() {
            setCellsInteractionEnabled(collectionView, to: false)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if viewModel.didReachMaxNumberOfApps() {
            setCellsInteractionEnabled(collectionView, to: true)
        }
        
        updateAndAnimateCollectionView(collectionView, for: indexPath)
        selectAppsView.updateAppCountText(to: viewModel.getSelectedAppsCount())
    }
    
    func setCellsInteractionEnabled(_ collectionView: UICollectionView, to value: Bool) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            guard let cell = collectionView.cellForItem(at: indexPath) as? AppCollectionViewCell,
                  !cell.isSelected else { continue }
            
            cell.isUserInteractionEnabled = value
        }
    }
    
    func updateAndAnimateCollectionView(_ collectionView: UICollectionView, for indexPath: IndexPath) {
        let oldData = viewModel.apps
        viewModel.toggleAppSelection(at: indexPath.row)
        let newData = viewModel.apps

        let changes = calculateMoves(from: oldData, to: newData)

        collectionView.performBatchUpdates({
            for move in changes {
                collectionView.moveItem(
                    at: IndexPath(row: move.from, section: 0),
                    to: IndexPath(row: move.to, section: 0)
                )
            }
        })
    }

    func calculateMoves(from oldData: [SelectableAppInfo], to newData: [SelectableAppInfo]) -> [(from: Int, to: Int)] {
        var moves = [(from: Int, to: Int)]()
        for (newIndex, newItem) in newData.enumerated() {
            if let oldIndex = oldData.firstIndex(where: { $0.data.name == newItem.data.name }) {
                if oldIndex != newIndex {
                    moves.append((from: oldIndex, to: newIndex))
                }
            }
        }
        return moves
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
        let app = viewModel.apps[indexPath.row]
        cell.setup(with: app)
        cell.isSelected = app.isSelected
        
        if viewModel.didReachMaxNumberOfApps() && !app.isSelected {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
}
