//
//  WidgetEditorViewController+UICollectionViewDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 01/10/24.
//

import UIKit
import WidgetStyling

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
            handleWidgetCellSelection(at: indexPath)
            
        case editorView.moduleStyleCollectionView:
            handleModuleStyleSelection(at: indexPath)
            
        case editorView.moduleColorCollectionView:
            handleModuleColorSelection(at: indexPath)
            
        default:
            return
        }
    }

    private func handleWidgetCellSelection(at indexPath: IndexPath) {
        if viewModel.selectedCellPosition == indexPath.row {
            clearSelectedModuleCell()
            return
        }
        
        dismissCurrentTip()
        selectModuleCell(at: indexPath.row)
    }

    private func handleModuleStyleSelection(at indexPath: IndexPath) {
        guard let style = viewModel.getAvailableStyle(at: indexPath.row) else {
            print("No styles found at \(indexPath.row)")
            return
        }
        
        selectStyleCell(style: style)
        
        let previousColors = viewModel.getAvailableColorsForSelectedModule()
        
        viewModel.applyStyleToSelectedModule(style) { [weak self] didSetToDefaultColor in
            self?.handleDefaultColorSelectionIfNeeded(didSetToDefaultColor)
        }
        
        let newColors = viewModel.getAvailableColorsForSelectedModule()
        updateColorCollectionView(previousColors: previousColors, newColors: newColors)
        
        editorView.widgetLayoutCollectionView.reloadData()
        editorView.moduleStyleCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }

    private func handleDefaultColorSelectionIfNeeded(_ didSetToDefaultColor: Bool) {
        guard didSetToDefaultColor,
              let selectedCellPosition = viewModel.selectedCellPosition else { return }
                
        let defaultColor = viewModel.getModule(at: selectedCellPosition)?.style.defaultColor
        
        guard let defaultColor else { return }
        
        selectColorCell(color: defaultColor)
    }

    private func updateColorCollectionView(previousColors: [UIColor], newColors: [UIColor]) {
        let (indexPathsToRemove, indexPathsToAdd) = calculateColorDifferences(
            previous: previousColors,
            new: newColors
        )
        
        editorView.moduleColorCollectionView.performBatchUpdates({ [weak self] in
            guard let self else { return }
            self.editorView.moduleColorCollectionView.deleteItems(at: indexPathsToRemove)
            self.editorView.moduleColorCollectionView.insertItems(at: indexPathsToAdd)
        })
    }

    private func handleModuleColorSelection(at indexPath: IndexPath) {
        guard let selectedCellPosition = viewModel.selectedCellPosition else {
            return
        }
        
        let availableColors = viewModel.getAvailableColorsForModule(at: selectedCellPosition)
        let color = availableColors[indexPath.row]
        
        selectColorCell(color: color)
        viewModel.applyColorToSelectedModule(color)
        editorView.widgetLayoutCollectionView.reloadData()
        editorView.moduleColorCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
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
            cell.setSelected(to: cell.style?.identifier == style.identifier)
        }
    }
    
    private func clearSelectedColorCell() {
        editorView.moduleColorCollectionView.subviews.forEach { cell in
            guard let cell = cell as? ModuleColorCell else { return }
            cell.setSelected(to: false)
        }
        
        editorView.moduleColorCollectionView.reloadData()
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
        let previousColors = viewModel.getAvailableColorsForSelectedModule()
        viewModel.setEditingCell(at: index)
        let newColors = viewModel.getAvailableColorsForSelectedModule()
        
        let (indexPathsToRemove, indexPathsToAdd) = calculateColorDifferences(
            previous: previousColors,
            new: newColors
        )
                
        editorView.moduleColorCollectionView.performBatchUpdates({
            editorView.moduleColorCollectionView.deleteItems(at: indexPathsToRemove)
            editorView.moduleColorCollectionView.insertItems(at: indexPathsToAdd)
        })
        
        editorView.enableStylingCollectionViews(
            didSelectEmptyCell: viewModel.isModuleEmpty(at: index) ?? false
        )
        
        editorView.widgetLayoutCollectionView.subviews.forEach { [weak self] cell in
            guard let cell = cell as? WidgetModuleCell else { return }
            
            let row = self?.editorView.widgetLayoutCollectionView.indexPath(for: cell)?.row
            cell.setEditable(self?.viewModel.selectedCellPosition == row)
        }
        
        guard let selectedStyle = viewModel.getStyleFromSelectedModule(),
              let selectedColor = viewModel.getColorFromSelectedModule()
        else { return }
        
        selectStyleCell(style: selectedStyle)
        selectColorCell(color: selectedColor)
        
        scrollToSelectedOptions()
    }
    
    private func calculateColorDifferences(
        previous: [UIColor],
        new: [UIColor]
    ) -> (toRemove: [IndexPath], toAdd: [IndexPath]) {
        let previousSet = Set(previous)
        let newSet = Set(new)
        
        let colorsToRemove = previousSet.subtracting(newSet)
        let colorsToAdd = newSet.subtracting(previousSet)
        
        var indexPathsToRemove: [IndexPath] = []
        var indexPathsToAdd: [IndexPath] = []
        
        for (index, color) in previous.enumerated() where colorsToRemove.contains(color) {
            indexPathsToRemove.append(IndexPath(item: index, section: 0))
        }
        
        for (index, color) in new.enumerated() where colorsToAdd.contains(color) {
            indexPathsToAdd.append(IndexPath(item: index, section: 0))
        }
        
        return (toRemove: indexPathsToRemove, toAdd: indexPathsToAdd)
    }

    private func scrollToSelectedOptions() {
        guard let styleIndex = viewModel.getIndexForSelectedStyle(),
              let colorIndex = viewModel.getIndexForSelectedModuleColor()
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
