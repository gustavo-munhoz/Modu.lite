//
//  GradientBackgroundView.swift
//  Modulite
//
//  Created by André Wozniack on 14/11/24.
//

import UIKit

class GradientBackgroundView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    init(gradient: Gradient) {
        super.init(frame: .zero)
        setupGradient(gradient: gradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient(gradient: Gradient) {
        gradientLayer.setup(with: gradient)

        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
