//
//  UILabel+Padded.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/09/24.
//

import UIKit

class PaddedLabel: UILabel {
    var edgeInsets: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: edgeInsets.bottom,
            right: edgeInsets.right
        )
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + edgeInsets.left + edgeInsets.right,
            height: size.height + edgeInsets.top + edgeInsets.bottom
        )
    }
}
