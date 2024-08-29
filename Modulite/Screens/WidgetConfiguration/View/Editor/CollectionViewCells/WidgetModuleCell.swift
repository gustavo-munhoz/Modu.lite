//
//  WidgetModuleCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit
import SnapKit

class WidgetModuleCell: UICollectionViewCell {
    static let reuseId = "WidgetModuleCell"
    
    // MARK: - Properties
        
    private(set) lazy var moduleImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
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
    }
    
    func setup(with module: ModuleConfiguration) {
        subviews.forEach { $0.removeFromSuperview() }
        moduleImageView.image = module.resultingImage
        
        if module.appName != nil {
            appNameLabel.text = module.appName
            appNameLabel.configure(with: module.textConfiguration)
        }
        
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
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.moduleImageView.alpha = value ?  1 : 0.5
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
