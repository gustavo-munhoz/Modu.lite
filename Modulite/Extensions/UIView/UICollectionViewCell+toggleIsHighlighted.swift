//
//  UICollectionViewCell+toggleIsHighlighted.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/09/24.
//

import UIKit

extension UICollectionViewCell {
    func toggleIsHighlighted() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut],
            animations: { [weak self] in
                
            guard let self = self else { return }
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
            CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
            CGAffineTransform.identity
        })
    }
}
