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
    
    private(set) lazy var styleImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Setup
    func setup(with image: UIImage) {
        subviews.forEach { $0.removeFromSuperview() }
        
        styleImageView.image = image
        
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
}
