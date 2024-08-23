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
        editorView.setCollectionViewDelegates(to: self)
        editorView.setCollectionViewDataSources(to: self)
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
        switch collectionView {
        case editorView.widgetLayoutCollectionView: return viewModel.displayedModules.count
        case editorView.moduleStyleCollectionView: return viewModel.availableStyles.count
        case editorView.moduleColorCollectionView: return viewModel.availableColors.count
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
        case editorView.widgetLayoutCollectionView:
            return handleLayoutCellCreation(for: collectionView, indexPath: indexPath)

        case editorView.moduleStyleCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ModuleStyleCell.reuseId,
                for: indexPath
            ) as? ModuleStyleCell else {
                fatalError("Could not dequeue ModuleStyleCell.")
            }
            
            cell.setup(
                with: viewModel.availableStyles[indexPath.row],
                blendColor: .lemonYellow
            )
            
            return cell
            
        case editorView.moduleColorCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ModuleColorCell.reuseId,
                for: indexPath
            ) as? ModuleColorCell else {
                fatalError("Could not dequeue ModuleColorCell.")
            }
            
            cell.setup(with: viewModel.availableColors[indexPath.row])
            
            return cell
        default:
            fatalError("Unsupported `UICollectionView`.")
        }
    }
    
    private func handleLayoutCellCreation(
        for collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if viewModel.displayedModules[indexPath.row] == nil {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WidgetEmptyCell.reuseId,
                for: indexPath
            ) as? WidgetEmptyCell else {
                fatalError("Could not dequeue WidgetEmptyCell.")
            }
            return cell
            
        } else {
            guard let image = viewModel.displayedModules[indexPath.row],
                  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WidgetLayoutCell.reuseId,
                for: indexPath
            ) as? WidgetLayoutCell else {
                fatalError("Could not dequeue WidgetLayoutCell.")
            }
            
            cell.setup(with: image)
            
            cell.startWiggling()
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension WidgetEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case editorView.widgetLayoutCollectionView:
            viewModel.setEditingCell(at: indexPath.row)
            
        case editorView.moduleColorCollectionView:
            guard let itemIndex = viewModel.editingCellWithIndex else {
                print("Tried to edit item without selecting any.")
                return
            }
            viewModel.applyColorToCell(
                at: itemIndex,
                color: viewModel.availableColors[indexPath.row]
            )
            
            editorView.widgetLayoutCollectionView.reloadData()
            
        default: return
        }
    }
}

// MARK: - UICollectionViewDragDelegate
extension WidgetEditorViewController: UICollectionViewDragDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard let item = viewModel.displayedModules[indexPath.row] else { return [] }
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
                    guard let viewModel = self?.viewModel
                    else { return }
                    
                    viewModel.moveItem(from: sourceIndexPath.item, to: destinationIndexPath.item)
                    
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
