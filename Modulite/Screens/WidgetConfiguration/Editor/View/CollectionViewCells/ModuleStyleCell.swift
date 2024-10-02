//
//  ModuleStyleCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/08/24.
//

import UIKit
import SnapKit

class ModuleStyleCell: UICollectionViewCell {
    static let reuseId = "ModuleStyleCell"
    
    // MARK: - Properties

    private var isModuleSelected: Bool = false
    
    weak var style: ModuleStyle?
    
    private(set) lazy var styleImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clear.cgColor
        
        return view
    }()
    
    // MARK: - Setup
    func setup(with style: ModuleStyle) {
        subviews.forEach { $0.removeFromSuperview() }
        
        self.style = style
        styleImageView.image = style.image
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(styleImageView)
    }
    
    private func setupConstraints() {
        styleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    func setSelected(to isSelected: Bool) {
        isModuleSelected = isSelected
        updateBorderAndShadow()
    }
    
    private func updateBorderAndShadow() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }

            if self.isModuleSelected {
                self.styleImageView.layer.borderColor = UIColor.systemGray.cgColor
                
                self.styleImageView.layer.masksToBounds = false
                self.styleImageView.layer.shadowRadius = 5
                self.styleImageView.layer.shadowColor = UIColor.black.cgColor
                self.styleImageView.layer.shadowOffset = CGSize(width: 4, height: 7)
                self.styleImageView.layer.shadowOpacity = 0.5
                
                return
            }
            
            self.styleImageView.layer.shadowOpacity = 0
            self.styleImageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
