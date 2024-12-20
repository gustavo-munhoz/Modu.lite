//
//  WidgetEditorViewController+UICollectionViewDragAndDropDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 01/10/24.
//

import UIKit
import WidgetStyling

// MARK: - UICollectionViewDragDelegate
extension WidgetEditorViewController: UICollectionViewDragDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard let item = viewModel.getModule(at: indexPath.row) else { return [] }
        
        let image = item.createCompleteImage(for: strategy)
        let itemProvider = NSItemProvider(object: image as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        clearSelectedModuleCell()
        
        return [dragItem]
    }
}

// MARK: - UICollectionViewDropDelegate
extension WidgetEditorViewController: UICollectionViewDropDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        canHandle session: any UIDropSession
    ) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: any UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: any UICollectionViewDropCoordinator
    ) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        switch coordinator.proposal.operation {
        case .move:
            let items = coordinator.items
            if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates { [weak self] in
                    guard let viewModel = self?.viewModel
                    else { return }
                    
                    viewModel.moveItem(from: sourceIndexPath.item, to: destinationIndexPath.item)
                    
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }
                
                coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
                
                sendDragDonationIfNeeded()
                clearSelectedModuleCell()
            }
        default:
            return
        }
    }
    
    private func sendDragDonationIfNeeded() {
        guard !hasCompletedDrag, isOnboarding else { return }
        
        Self.didDragModule.sendDonation()
        
        hasCompletedDrag = true
    }
}
