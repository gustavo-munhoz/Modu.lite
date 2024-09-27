//
//  WidgetEditorViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

protocol WidgetEditorViewControllerDelegate: AnyObject {
    func widgetEditorViewController(
        _ viewController: WidgetEditorViewController,
        didSave widget: ModuliteWidgetConfiguration
    )
}

class WidgetEditorViewController: UIViewController {
    
    // MARK: - Properties
    private let editorView = WidgetEditorView()
    private var viewModel: WidgetEditorViewModel!
    
    weak var delegate: WidgetEditorViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = editorView
        editorView.setCollectionViewDelegates(to: self)
        editorView.setCollectionViewDataSources(to: self)
        editorView.onDownloadWallpaperButtonTapped = handleDownloadWallpaperTouch
        editorView.onSaveButtonTapped = handleSaveWidgetButtonTouch
        
        if let background = viewModel.getWidgetBackground() {
            editorView.setWidgetBackground(to: background)
        }
    }
    
    // MARK: - Actions
    private func handleDownloadWallpaperTouch() {
        do {
            try viewModel.saveWallpaperImageToPhotos()
            presentWallpaperSaveAlert(success: true)
            disableWallpaperDownloadButton()
            
        } catch {
            presentWallpaperSaveAlert(success: false)
        }
    }
    
    private func disableWallpaperDownloadButton() {
        editorView.downloadWallpaperButton.isEnabled = false
    }
    
    private func presentWallpaperSaveAlert(success: Bool) {
        // TODO: Implement alert messages
        let alert = UIAlertController(
            title: success ? "Success" : "Error",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func handleSaveWidgetButtonTouch() {
        clearSelectedModuleCell()
        
        let widget = viewModel.saveWidget(from: editorView.widgetLayoutCollectionView)
        delegate?.widgetEditorViewController(self, didSave: widget)
    }
}

extension WidgetEditorViewController {
    class func instantiate(
        builder: WidgetConfigurationBuilder,
        delegate: WidgetEditorViewControllerDelegate
    ) -> WidgetEditorViewController {
        let vc = WidgetEditorViewController()
        
        vc.viewModel = WidgetEditorViewModel(widgetBuider: builder)
        vc.delegate = delegate
        
        return vc
    }
    
    func loadDataFromBuilder(_ builder: WidgetConfigurationBuilder) {
        viewModel = WidgetEditorViewModel(widgetBuider: builder)
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

// MARK: - UICollectionViewDelegate
extension WidgetEditorViewController: UICollectionViewDelegate {
    
    // MARK: - Change internal collectionView's position based on scroll %
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
            if viewModel.selectedCellIndex == indexPath.row {
                clearSelectedModuleCell()
                return
            }
            
            selectModuleCell(at: indexPath.row)
            
        case editorView.moduleStyleCollectionView:
            // MARK: - Handle module style touch
            
            guard let style = viewModel.getAvailableStyle(at: indexPath.row) else {
                print("No styles found at \(indexPath.row)")
                return
            }
            
            selectStyleCell(style: style)
            viewModel.applyStyleToSelectedModule(style)
            editorView.widgetLayoutCollectionView.reloadData()
            
        case editorView.moduleColorCollectionView:
            // MARK: - Handle module color touch
            
            guard let color = viewModel.getAvailableColor(at: indexPath.row) else {
                print("No colors found at \(indexPath.row)")
                return
            }
            
            selectColorCell(color: color)
            viewModel.applyColorToSelectedModule(color)
            editorView.widgetLayoutCollectionView.reloadData()
            
        default: return
        }
    }
    
    private func clearSelectedStyleCell() {
        editorView.moduleStyleCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? ModuleStyleCell else { return }
            cell.setSelected(to: false)
        }
    }
    
    private func selectStyleCell(style: ModuleStyle) {
        editorView.moduleStyleCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? ModuleStyleCell else { return }
            cell.setSelected(to: cell.style?.id == style.id)
        }
    }
    
    private func clearSelectedColorCell() {
        editorView.moduleColorCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? ModuleColorCell else { return }
            cell.setSelected(to: false)
        }
    }
    
    private func selectColorCell(color: UIColor) {
        editorView.moduleColorCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? ModuleColorCell else { return }
            cell.setSelected(to: cell.color == color)
        }
    }
    
    private func clearSelectedModuleCell() {
        viewModel.clearEditingCell()
        editorView.disableStylingCollectionViews()
        editorView.widgetLayoutCollectionView.subviews.forEach { cell in
            guard let cell = cell as? WidgetModuleCell else { return }
            cell.setEditable(true)
        }
        clearSelectedStyleCell()
        clearSelectedColorCell()
    }
    
    private func selectModuleCell(at index: Int) {
        viewModel.setEditingCell(at: index)
        editorView.enableStylingCollectionViews(
            didSelectEmptyCell: viewModel.isModuleEmpty(at: index)
        )
        
        // FIXME: - use `cellForItemAt`
        editorView.widgetLayoutCollectionView.subviews.forEach { [weak self] cell in
            guard let cell = cell as? WidgetModuleCell else { return }
            
            let row = self?.editorView.widgetLayoutCollectionView.indexPath(for: cell)?.row
            cell.setEditable(self?.viewModel.selectedCellIndex == row)
        }
        
        guard let selectedStyle = viewModel.getStyleFromSelectedModule(),
              let selectedColor = viewModel.getColorFromSelectedModule()
        else { return }
        
        selectStyleCell(style: selectedStyle)
        selectColorCell(color: selectedColor)
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
