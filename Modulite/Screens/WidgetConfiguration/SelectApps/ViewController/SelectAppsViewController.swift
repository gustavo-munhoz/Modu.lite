//
//  SelectAppsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit
import WidgetStyling

protocol SelectAppsViewControllerDelegate: AnyObject {
    func selectAppsViewControllerDidSelectApp(
        _ controller: SelectAppsViewController,
        didSelect app: AppData
    )
    
    func selectAppsViewControllerDidDeselectApp(
        _ controller: SelectAppsViewController,
        didDeselect app: AppData
    )
}

class SelectAppsViewController: UIViewController {
    
    // MARK: - Properties
    private let selectAppsView = SelectAppsView()
    private let viewModel = SelectAppsViewModel()
    
    weak var delegate: SelectAppsViewControllerDelegate?
    
    var maxApps: Int! {
        didSet {
            viewModel.maxApps = maxApps
        }
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = selectAppsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        selectAppsView.setCollectionViewDelegate(to: self)
        selectAppsView.setCollectionViewDataSource(to: self)
        selectAppsView.setSearchBarDelegate(to: self)
    }
}

extension SelectAppsViewController {
    class func instantiate(
        with delegate: SelectAppsViewControllerDelegate,
        selectedApps: [AppData] = [],
        maxApps: Int
    ) -> SelectAppsViewController {
        
        let vc = SelectAppsViewController()
        vc.delegate = delegate
        vc.maxApps = maxApps
        
        selectedApps.forEach { vc.viewModel.selectApp($0) }
        
        vc.selectAppsView.updateAppCountText(to: selectedApps.count, of: maxApps)
        
        return vc
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
        guard let app = updateAndAnimateCollectionView(collectionView, for: indexPath) else {
            print("View model return nil from deselect app.")
            return
        }
        
        delegate?.selectAppsViewControllerDidSelectApp(self, didSelect: app)
        
        selectAppsView.updateAppCountText(to: viewModel.getSelectedAppsCount(), of: maxApps)
        
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
                
        guard let app = updateAndAnimateCollectionView(collectionView, for: indexPath) else {
            print("View model return nil from select app.")
            return
        }
        
        delegate?.selectAppsViewControllerDidDeselectApp(self, didDeselect: app)
        
        selectAppsView.updateAppCountText(to: viewModel.getSelectedAppsCount(), of: maxApps)
    }
    
    func setCellsInteractionEnabled(_ collectionView: UICollectionView, to value: Bool) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            guard let cell = collectionView.cellForItem(at: indexPath) as? AppCollectionViewCell,
                  !cell.isSelected else { continue }
            
            cell.isUserInteractionEnabled = value
        }
    }
    
    @discardableResult
    private func updateAndAnimateCollectionView(
        _ collectionView: UICollectionView,
        for indexPath: IndexPath
    ) -> AppData? {
        
        let oldData = viewModel.apps
        let changedApp = viewModel.toggleAppSelection(at: indexPath.row)
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
        
        return changedApp?.data
    }

    private func calculateMoves(
        from oldData: [SelectableAppData],
        to newData: [SelectableAppData]
    ) -> [(from: Int, to: Int)] {
        
        var moves = [(from: Int, to: Int)]()
        var usedOldIndices = Set<Int>()
        
        for (newIndex, newItem) in newData.enumerated() {
            var oldIndex: Int?
            for (index, oldItem) in oldData.enumerated() {
                if !usedOldIndices.contains(index) &&
                   oldItem.data.name == newItem.data.name &&
                   oldItem.isSelected == newItem.isSelected {
                    oldIndex = index
                    break
                }
            }
            if let oldIndex = oldIndex {
                if oldIndex != newIndex {
                    moves.append((from: oldIndex, to: newIndex))
                }
                usedOldIndices.insert(oldIndex)
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
        
        if app.isSelected {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        
        if viewModel.didReachMaxNumberOfApps() && !app.isSelected {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
}

extension SelectAppsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterApps(with: searchText)
        selectAppsView.appsCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
