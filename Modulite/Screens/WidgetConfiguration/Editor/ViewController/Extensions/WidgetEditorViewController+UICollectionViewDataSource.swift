//
//  WidgetEditorViewController+UICollectionViewDataSource.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 01/10/24.
//

import UIKit

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
            
            if let selectedStyle = viewModel.getStyleFromSelectedModule() {
                cell.setSelected(to: selectedStyle.key == style.key)
            }
            
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
            
            if let selectedColor = viewModel.getColorFromSelectedModule() {
                cell.setSelected(to: selectedColor == color)
            }
            
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
