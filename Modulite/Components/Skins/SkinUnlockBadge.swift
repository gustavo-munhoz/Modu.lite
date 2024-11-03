//
//  SkinUnlockBadge.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import UIKit

class SkinUnlockBadge: GradientLabelView {
    
    convenience init () {
        self.init(
            gradient: .ambrosia(),
            insets: .init(vertical: 5, horizontal: 5)
        )
        
        textAlignment = .center
        attributedText = CustomizedTextFactory.createFromMarkdown(
            with: .localized(for: BadgeLocalizedTexts.skinUnlockBadgeText)
        )
    }
}
