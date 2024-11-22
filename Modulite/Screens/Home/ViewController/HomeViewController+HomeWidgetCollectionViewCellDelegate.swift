//
//  HomeViewController+HomeWidgetCollectionViewCellDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/11/24.
//

import UIKit
import WidgetStyling

extension HomeViewController: HomeWidgetCollectionViewCellDelegate {
    private func findCollectionViewAndIndexPath(
        for cell: HomeWidgetCollectionViewCell
    ) -> (UICollectionView, IndexPath)? {
        if let indexPath = homeView.mainWidgetsCollectionView.indexPath(for: cell) {
            return (homeView.mainWidgetsCollectionView, indexPath)
        }
        
        if let indexPath = homeView.auxiliaryWidgetsCollectionView.indexPath(for: cell) {
            return (homeView.auxiliaryWidgetsCollectionView, indexPath)
        }
        
        return nil
    }

    // MARK: - Delegate Methods

    func homeWidgetCellDidRequestEdit(_ cell: HomeWidgetCollectionViewCell) {
        guard let (collectionView, indexPath) = findCollectionViewAndIndexPath(for: cell) else {
            print("Could not find collection view or index path for cell.")
            return
        }
        
        let widget: WidgetSchema
        if collectionView == homeView.mainWidgetsCollectionView {
            widget = viewModel.mainWidgets[indexPath.row]
        } else {
            widget = viewModel.auxiliaryWidgets[indexPath.row]
        }
        
        delegate?.homeViewControllerDidStartWidgetEditingFlow(self, widget: widget)
    }

    func homeWidgetCellDidRequestDelete(_ cell: HomeWidgetCollectionViewCell) {
        guard let (collectionView, indexPath) = findCollectionViewAndIndexPath(for: cell) else {
            print("Could not find collection view or index path for cell.")
            return
        }
        
        presentWidgetDeletionWarning(for: cell, in: indexPath, in: collectionView)
    }

    // MARK: - Widget Deletion

    private func presentWidgetDeletionWarning(
        for cell: HomeWidgetCollectionViewCell,
        in indexPath: IndexPath,
        in collectionView: UICollectionView
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
            
            let widget: WidgetSchema
            if collectionView == self.homeView.mainWidgetsCollectionView {
                widget = self.viewModel.mainWidgets[indexPath.row]
            } else {
                widget = self.viewModel.auxiliaryWidgets[indexPath.row]
            }
            
            self.deleteWidget(widget, type: widget.type)
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
