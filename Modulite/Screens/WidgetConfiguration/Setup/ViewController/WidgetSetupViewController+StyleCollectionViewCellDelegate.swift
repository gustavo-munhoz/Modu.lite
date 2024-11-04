//
//  WidgetSetupViewController+StyleCollectionViewCellDelegate.swift
//  Modulite
//
//  Created by André Wozniack on 30/10/24.
//

import Foundation

extension WidgetSetupViewController: StyleCollectionViewCellDelegate {
    func styleCollectionViewCellDidPressPreview(_ cell: StyleCollectionViewCell) {
        guard let indexPath = setupView.stylesCollectionView.indexPath(for: cell) else { return }
        
        let style = viewModel.widgetStyles[indexPath.row]
        
        delegate?.widgetSetupViewControllerShouldPresentPreview(self, for: style)
    }
}
