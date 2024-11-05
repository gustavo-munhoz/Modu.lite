//
//  GradientButton.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import UIKit
import SnapKit

class GradientButton: UIButton {

    private let gradientLayer = CAGradientLayer()
    private var insets: UIEdgeInsets?
    
    init(
        frame: CGRect = .zero,
        gradient: Gradient,
        insets: UIEdgeInsets? = nil
    ) {
        self.insets = insets
        super.init(frame: frame)
        setupGradientLayer(gradient)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupGradientLayer(_ gradient: Gradient) {
        gradientLayer.setup(with: gradient)
        gradientLayer.cornerRadius = 8
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupButton() {
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        setTitleColor(.white, for: .normal)
        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func setButtonText(_ text: String) {
        setTitle(text, for: .normal)
    }
    
    func setButtonFont(_ font: UIFont) {
        titleLabel?.font = font
    }
}
