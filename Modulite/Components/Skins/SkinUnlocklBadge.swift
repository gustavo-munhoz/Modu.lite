//
//  SkinUnlockBadge.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import UIKit

class SkinUnlockBadge: GradientLabelView {
    convenience init() {
        self.init(
            gradient: .ambrosia(),
            insets: .init(vertical: 5, horizontal: 5)
        )
        
        textAlignment = .center
        attributedText = NSAttributedString(
            string: .localized(for: .plus),
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(
                    ofSize: 16,
                    weight: .heavy,
                    width: .expanded
                )
            ]
        )
        
        layer.cornerRadius = 6.25
        clipsToBounds = true
    }
}
