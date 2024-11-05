//
//  WidgetSetupViewController+SelectedAppCollectionViewCellDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

// MARK: - SelectedAppCollectionViewCellDelegate
extension WidgetSetupViewController: SelectedAppCollectionViewCellDelegate {
    func selectedAppCollectionViewCellDidPressDelete(_ cell: SelectedAppCollectionViewCell) {
        guard let indexPath = setupView.selectedAppsCollectionView.indexPath(for: cell) else {
            print("Could not get IndexPath for app cell")
            return
        }
        
        didMakeChangesToWidget = true
        
        let app = viewModel.selectedApps[indexPath.row]
        viewModel.removeSelectedApp(app)
        delegate?.widgetSetupViewControllerDidDeselectApp(self, app: app)
        setupView.selectedAppsCollectionView.performBatchUpdates({ [weak self] in
            self?.setupView.selectedAppsCollectionView.deleteItems(at: [indexPath])
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.setupView.setNeedsLayout()
                self?.setupView.layoutIfNeeded()
            }
        })
    }
}
