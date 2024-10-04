//
//  ModulitePlusSmallBadge.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/10/24.
//

import UIKit

class ModulitePlusSmallBadge: GradientLabelView {
    
    convenience init() {
        self.init(
            gradient: .tropical(),
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
