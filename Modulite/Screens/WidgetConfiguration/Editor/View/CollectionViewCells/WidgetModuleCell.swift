//
//  WidgetModuleCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit
import SnapKit
import WidgetStyling

class WidgetModuleCell: UICollectionViewCell {
    static let reuseId = "WidgetModuleCell"
    
    // MARK: - Properties
        
    private(set) lazy var moduleImageView: UIImageView = {
        let view = UIImageView()
        view.overrideUserInterfaceStyle = .light
        view.backgroundColor = .clear
        
        return view
    }()
    
    private(set) lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        return label
    }()
    
    // MARK: - Setup Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setEditable(false)
        stopWiggling()
        moduleImageView.alpha = 0.5
        appNameLabel.alpha = 0.5
        appNameLabel.text = nil
    }
    
    func setup(
        with module: WidgetModule,
        cornerRadius: CGFloat
    ) {
        subviews.forEach { $0.removeFromSuperview() }
        moduleImageView.image = module.blendedImage
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        if let appName = module.appName {
            appNameLabel.text = appName
            appNameLabel.applyConfiguration(module.style.textConfiguration)
        }
        
        backgroundColor = .clear
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(moduleImageView)
        addSubview(appNameLabel)
    }
    
    private func setupConstraints() {
        moduleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(snp.bottom).multipliedBy(0.82)
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    func setEditable(_ value: Bool) {
        if !value && self.moduleImageView.alpha == 0.5 { return }
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.moduleImageView.alpha = value ?  1 : 0.5
            self?.appNameLabel.alpha = value ?  1 : 0.5
        }
        if value { startWiggling() } else { stopWiggling() }
    }
}

extension WidgetModuleCell {
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
