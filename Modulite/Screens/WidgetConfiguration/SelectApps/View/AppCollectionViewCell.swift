//
//  AppCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/09/24.
//

import UIKit
import SnapKit

class AppCollectionViewCell: UICollectionViewCell {
    static let reuseId = "AppCollectionViewCell"
    // MARK: - Properties
    
    private(set) lazy var selectedImageView: UIImageView = {
        let view = UIImageView(
            image: UIImage(systemName: "circle")?.withTintColor(
                .carrotOrange,
                renderingMode: .alwaysOriginal
            )
        )
        
        return view
    }()
    
    private(set) lazy var appNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    // MARK: - Setup methods
    
    func setup(with app: AppInfo) {
        subviews.forEach { $0.removeFromSuperview() }
        
        appNameLabel.text = app.name
        
        addSubviews()
        setupContraints()
    }
    
    private func addSubviews() {
        addSubview(selectedImageView)
        addSubview(appNameLabel)
    }
    
    private func setupContraints() {
        selectedImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview().priority(.required)
            make.width.height.equalTo(20)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.left.equalTo(selectedImageView.snp.right).offset(15)
            make.right.top.bottom.equalToSuperview()
        }
    }
}
