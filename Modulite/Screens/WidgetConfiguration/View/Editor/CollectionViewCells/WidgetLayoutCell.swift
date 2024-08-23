//
//  WidgetLayoutCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit

class WidgetLayoutCell: UICollectionViewCell {
    static let reuseId = "WidgetLayoutCell"
    
    // MARK: - Properties
    private(set) lazy var moduleImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Setup Methods
    
    func setup(with image: UIImage, blendColor: UIColor? = nil) {
        subviews.forEach { $0.removeFromSuperview() }
        
        if let color = blendColor {
            moduleImageView.image = ImageProcessingFactory.createColorBlendedImage(
                image,
                mode: .plusDarker,
                color: color
            )
        } else {
            moduleImageView.image = image
        }
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(moduleImageView)
    }
    
    private func setupConstraints() {
        moduleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension WidgetLayoutCell {
    func startWiggling() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = -0.03
        rotation.toValue = 0.03
        rotation.duration = 0.1
        rotation.repeatCount = Float.infinity
        rotation.autoreverses = true

        layer.add(rotation, forKey: "rotation")

    }

    func stopWiggling() {
        layer.removeAllAnimations()
    }
}
