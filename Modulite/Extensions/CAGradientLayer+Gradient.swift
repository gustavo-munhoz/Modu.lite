//
//  CAGradientLayer+Gradient.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/10/24.
//

import UIKit

extension CAGradientLayer {
    func setup(with gradient: Gradient) {
        colors = gradient.colors
        startPoint = gradient.startPoint
        endPoint = gradient.endPoint
    }
}
