//
//  WidgetEditorViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetEditorViewController: UIViewController {
    
    private let editorView = WidgetEditorView()
    private let viewModel = WidgetEditorViewModel()
    
    override func loadView() {
        view = editorView
        editorView.setLayoutCollectionViewDelegate(to: self)
        editorView.setLayoutCollectionViewDataSource(to: self)
    }
    
}

extension WidgetEditorViewController {
    class func instantiate(widgetId: UUID, delegate: HomeNavigationFlowDelegate) -> WidgetEditorViewController {
        let vc = WidgetEditorViewController()
        vc.viewModel.setWidgetId(to: widgetId)
        vc.viewModel.setDelegate(to: delegate)
        
        return vc
    }
}

// MARK: - UICollectionViewDataSource
extension WidgetEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === editorView.widgetLayoutCollectionView {
            return viewModel.displayedApps.count - 1
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
        case editorView.widgetLayoutCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WidgetLayoutCell.reuseId,
                for: indexPath
            ) as? WidgetLayoutCell else { fatalError("Could not dequeue `WidgetLayoutCell`.")}
            
            return cell
        default:
            fatalError("Unsupported `UICollectionView`.")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension WidgetEditorViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDragDelegate
extension WidgetEditorViewController: UICollectionViewDragDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        let item = viewModel.displayedApps[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
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
                    guard let viewModel = self?.viewModel,
                          let image = item.dragItem.localObject as? UIImage
                    else { return }
                    
                    viewModel.removeCell(at: sourceIndexPath.item)
                    viewModel.insertCell(image, at: destinationIndexPath.item)
                    
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }
                
                coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
            }
        default:
            return
        }
    }
}
