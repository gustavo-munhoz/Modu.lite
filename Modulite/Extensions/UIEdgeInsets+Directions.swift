//
//  UIEdgeInsets+Directions.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/09/24.
//

import UIKit

extension UIEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }
}
