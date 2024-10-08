//
//  ModuliteFreeSmallBadge.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import UIKit

class ModuliteFreeSmallBadge: GradientLabelView {
    convenience init() {
        self.init(
            gradient: Gradient(
                colors: [.potatoYellow, .potatoYellow],
                direction: CGVector(dx: 1, dy: 0)
            ),
            insets: .init(vertical: 5, horizontal: 5)
        )
        
        textAlignment = .center
        attributedText = NSAttributedString(
            string: .localized(for: .free),
            attributes: [
                .foregroundColor: UIColor.textPrimary,
                .font: UIFont.systemFont(
                    ofSize: 16,
                    weight: .heavy,
                    width: .expanded
                )
            ]
        )
        
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}