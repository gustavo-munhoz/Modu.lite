//
//  WidgetEditorViewController+UICollectionViewDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 01/10/24.
//

import UIKit

extension WidgetEditorViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === editorView {
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
            if bottomEdge >= scrollView.contentSize.height {
                sendEditModuleEventIfNeeded()
            }
        }
    }
    
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
            
            dismissCurrentTip()
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
            editorView.moduleStyleCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
            
        case editorView.moduleColorCollectionView:
            // MARK: - Handle module color touch
            
            guard let color = viewModel.getAvailableColor(at: indexPath.row) else {
                print("No colors found at \(indexPath.row)")
                return
            }
            
            selectColorCell(color: color)
            viewModel.applyColorToSelectedModule(color)
            editorView.widgetLayoutCollectionView.reloadData()
            editorView.moduleColorCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
            
        default: return
            
        }
    }
    
    private func sendEditModuleEventIfNeeded() {
        guard hasCompletedDrag, !hasCompletedEdit, isOnboarding else { return }
        
        Self.didEditModule.sendDonation()
        hasCompletedEdit = true
    }
    
    private func clearSelectedStyleCell() {
        editorView.moduleStyleCollectionView.subviews.forEach { cell in
            guard let cell = cell as? ModuleStyleCell else { return }
            cell.setSelected(to: false)
        }
    }
    
    private func selectStyleCell(style: ModuleStyle) {
        editorView.moduleStyleCollectionView.subviews.forEach { cell in
            guard let cell = cell as? ModuleStyleCell else { return }
            cell.setSelected(to: cell.style?.key == style.key)
        }
    }
    
    private func clearSelectedColorCell() {
        editorView.moduleColorCollectionView.subviews.forEach { cell in
            guard let cell = cell as? ModuleColorCell else { return }
            cell.setSelected(to: false)
        }
    }
    
    private func selectColorCell(color: UIColor) {
        editorView.moduleColorCollectionView.subviews.forEach { cell in
            guard let cell = cell as? ModuleColorCell else { return }
            cell.setSelected(to: cell.color == color)
        }
    }
    
    func clearSelectedModuleCell() {
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
        
        scrollToSelectedOptions()
    }
    
    private func scrollToSelectedOptions() {
        guard let styleIndex = viewModel.getIndexForSelectedStyle(),
              let colorIndex = viewModel.getIndexForSelectedColor()
        else { return }
        
        let styleIndexPath = IndexPath(item: styleIndex, section: 0)
        editorView.moduleStyleCollectionView.scrollToItem(
            at: styleIndexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        let colorIndexPath = IndexPath(item: colorIndex, section: 0)
        editorView.moduleColorCollectionView.scrollToItem(
            at: colorIndexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}
