//
//  WidgetModuleCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit

class WidgetModuleCell: UICollectionViewCell {
    static let reuseId = "WidgetModuleCell"
    
    // MARK: - Properties
        
    private(set) lazy var moduleImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
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
