//
//  WidgetEditorViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetEditorViewController: UIViewController {
    
    private let editorView = WidgetEditorView()
    private var viewModel: WidgetEditorViewModel!
    
    override func loadView() {
        view = editorView
        editorView.setCollectionViewDelegates(to: self)
        editorView.setCollectionViewDataSources(to: self)
    }
}

extension WidgetEditorViewController {
    class func instantiate(
        builder: WidgetConfigurationBuilder,
        delegate: HomeNavigationFlowDelegate
    ) -> WidgetEditorViewController {
        let vc = WidgetEditorViewController()
        vc.viewModel = WidgetEditorViewModel(widgetBuider: builder, delegate: delegate)
        
        return vc
    }
}

// MARK: - UICollectionViewDataSource
extension WidgetEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case editorView.widgetLayoutCollectionView: return viewModel.getCurrentModules().count
        case editorView.moduleStyleCollectionView: return viewModel.getAvailableStyles().count
        case editorView.moduleColorCollectionView: return viewModel.getAvailableColors().count
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
        case editorView.widgetLayoutCollectionView:
            // MARK: - Create cells for widget
            return handleLayoutCellCreation(for: collectionView, indexPath: indexPath)

        case editorView.moduleStyleCollectionView:
            // MARK: - Create cells for module styles
            guard let style = viewModel.getAvailableStyle(at: indexPath.row),
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ModuleStyleCell.reuseId,
                    for: indexPath
                  ) as? ModuleStyleCell else {
                fatalError("Could not dequeue ModuleStyleCell.")
            }
            
            cell.setup(with: style)
            return cell
            
        case editorView.moduleColorCollectionView:
            // MARK: - Create cells for colors
            guard let color = viewModel.getAvailableColor(at: indexPath.row),
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ModuleColorCell.reuseId,
                    for: indexPath
                  ) as? ModuleColorCell else {
                fatalError("Could not dequeue ModuleColorCell.")
            }
            
            cell.setup(with: color)
            return cell
            
        default:
            fatalError("Unsupported `UICollectionView`.")
        }
    }
    
    private func handleLayoutCellCreation(
        for collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        if viewModel.isModuleEmpty(at: indexPath.row) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WidgetEmptyCell.reuseId,
                for: indexPath
            ) as? WidgetEmptyCell else {
                fatalError("Could not dequeue WidgetEmptyCell.")
            }
            return cell
            
        } else {
            guard let module = viewModel.getModule(at: indexPath.row),
                  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WidgetModuleCell.reuseId,
                for: indexPath
            ) as? WidgetModuleCell else {
                fatalError("Could not dequeue WidgetModuleCell.")
            }
            
            if let index = viewModel.selectedCellIndex {
                cell.setEditable(index == indexPath.row)
            } else {
                cell.startWiggling()
            }
            
            cell.setup(with: module)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension WidgetEditorViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalScrollWidth = scrollView.contentSize.width - scrollView.bounds.width
        let currentScrollPosition = scrollView.contentOffset.x
        let scrollPercentage = currentScrollPosition / totalScrollWidth
        
        if scrollView === editorView.moduleStyleCollectionView {
            editorView.updateCollectionViewConstraints(
                editorView.moduleStyleCollectionView,
                percentage: scrollPercentage
            )
        }
        
        if scrollView === editorView.moduleColorCollectionView {
            editorView.updateCollectionViewConstraints(
                editorView.moduleColorCollectionView,
                percentage: scrollPercentage
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case editorView.widgetLayoutCollectionView:
            // MARK: - Handle widget cell touch
            
            if viewModel.isModuleEmpty(at: indexPath.row) {
                // TODO: Handle creating new cell
                return
            }
            
            if viewModel.selectedCellIndex == indexPath.row {
                clearSelectedCell(in: collectionView)
                return
            }
            
            selectCell(in: collectionView, at: indexPath.row)
            
        case editorView.moduleStyleCollectionView:
            // MARK: - Handle module style touch
            
            guard let style = viewModel.getAvailableStyle(at: indexPath.row) else {
                print("No styles found at \(indexPath.row)")
                return
            }
            
            viewModel.applyStyleToSelectedCell(style)
            editorView.widgetLayoutCollectionView.reloadData()
            
        case editorView.moduleColorCollectionView:
            // MARK: - Handle module color touch
            
            guard let color = viewModel.getAvailableColor(at: indexPath.row) else {
                print("No colors found at \(indexPath.row)")
                return
            }
            
            viewModel.applyColorToSelectedCell(color)
            editorView.moduleStyleCollectionView.reloadData()
            editorView.widgetLayoutCollectionView.reloadData()
            
        default: return
        }
    }
    
    private func clearSelectedCell(in collectionView: UICollectionView) {
        viewModel.clearEditingCell()
        editorView.disableStylingCollectionViews()
        collectionView.subviews.forEach { cell in
            guard let cell = cell as? WidgetModuleCell else { return }
            cell.setEditable(true)
        }
    }
    
    private func selectCell(in collectionView: UICollectionView, at index: Int) {
        viewModel.setEditingCell(at: index)
        editorView.enableStylingCollectionViews()
        
        collectionView.subviews.forEach { cell in
            guard let cell = cell as? WidgetModuleCell else { return }
            
            let row = collectionView.indexPath(for: cell)?.row
            cell.setEditable(viewModel.selectedCellIndex == row)
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
        guard let item = viewModel.getModule(at: indexPath.row),
              let image = item.resultingImage
        else { return [] }
        
        let itemProvider = NSItemProvider(object: image as UIImage)
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
