//
//  WidgetSetupViewController+UICollectionViewDataSource.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit
import WidgetStyling

// MARK: - UICollectionViewDataSource
extension WidgetSetupViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section != 0 else { return 0 }
        
        switch collectionView {
        case setupView.stylesCollectionView: return viewModel.widgetStyles.count
        case setupView.selectedAppsCollectionView: return viewModel.selectedApps.count
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
        case setupView.stylesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StyleCollectionViewCell.reuseId,
                for: indexPath
            ) as? StyleCollectionViewCell else {
                fatalError("Could not dequeue StyleCollectionViewCell")
            }
            
            let style = viewModel.widgetStyles[indexPath.row]
            
            let isAvailable = IsStyleAvailableSpecification(
                styleIdentifier: style.identifier
            ).isSatisfied()
            
            cell.setup(
                image: style.getWidgetPreview(for: strategy.type),
                title: style.name,
                delegate: self,
                isAvailable: isAvailable,
                imageViewHeight: strategy.getStyleCellImageHeight()
            )
            
            cell.hasSelectionBeenMade = viewModel.isStyleSelected()
            
            if let selectedStyle = viewModel.selectedStyle,
               selectedStyle.isEqual(to: style) {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            
            return cell
            
        case setupView.selectedAppsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedAppCollectionViewCell.reuseId,
                for: indexPath
            ) as? SelectedAppCollectionViewCell else {
                fatalError("Could not dequeue StyleCollectionViewCell")
            }
            
            cell.setup(with: viewModel.selectedApps[indexPath.row].name)
            cell.delegate = self
            
            return cell
        
        default: fatalError("Unsupported View Controller.")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SetupHeaderReusableCell.reuseId,
            for: indexPath
        ) as? SetupHeaderReusableCell else {
            fatalError("Could not dequeue SetupHeader cell.")
        }
        
        if collectionView === setupView.stylesCollectionView {
            header.setup(title: .localized(for: .widgetSetupViewStyleHeaderTitle))
            
        } else {
            header.setup(
                title: .localized(
                    for: .widgetSetupViewAppsHeaderTitle(maxApps: strategy.type.maxModules)
                )
            )
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WidgetSetupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let text = viewModel.selectedApps[indexPath.row].name
        let font = UIFont(textStyle: .title3, weight: .semibold)
        let size = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        
        return CGSize(width: size.width + 45, height: size.height + 24)
    }
}
