//
//  UIView+animateBorderColor.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import UIKit

extension UIView {
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
}
