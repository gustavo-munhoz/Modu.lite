//
//  StyleCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit
import SnapKit

class StyleCollectionViewCell: UICollectionViewCell {
    static let reuseId = "StyleCollectionViewCell"
    
    private(set) lazy var styleImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        return view
    }()
    
    private(set) lazy var styleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        
        return label
    }()    
    
    func setup(image: UIImage, title: String) {
        subviews.forEach { $0.removeFromSuperview() }
        
        styleImageView.image = image
        styleTitle.text = title
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(styleImageView)
        addSubview(styleTitle)
    }
    
    private func setupConstraints() {
        styleImageView.snp.makeConstraints { make in
            make.height.equalTo(187)
            make.left.right.top.equalToSuperview()
        }
        
        styleTitle.snp.makeConstraints { make in
            make.top.equalTo(styleImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
    }
}
