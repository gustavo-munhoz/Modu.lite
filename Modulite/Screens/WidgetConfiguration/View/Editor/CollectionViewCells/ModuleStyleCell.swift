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
        updateBorder()
    }
    
    private func updateBorder() {
        if isModuleSelected {
            styleImageView.layer.borderColor = UIColor.textPrimary.cgColor
            
        } else {
            styleImageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
