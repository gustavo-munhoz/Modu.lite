//
//  ModuleStyleCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/08/24.
//

import UIKit

class ModuleStyleCell: UICollectionViewCell {
    static let reuseId = "ModuleStyleCell"
    
    // MARK: - Properties
    
    private(set) lazy var styleImageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    // MARK: - Setup
    func setup(with image: UIImage) {
        styleImageView.image = image
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(styleImageView)
    }
    
    func setupConstraints() {
        styleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
