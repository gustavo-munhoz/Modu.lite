//
//  SelectedAppCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 16/08/24.
//

import UIKit
import SnapKit

class SelectedAppCollectionViewCell: UICollectionViewCell {
    static let reuseId = "SelectedAppCollectionViewCell"
    
    // MARK: - Properties
    
    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(textStyle: .title3, weight: .semibold)
        
        return view
    }()
    
    private(set) lazy var removeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: "xmark")?.withTintColor(
            .carrotOrange,
            renderingMode: .alwaysOriginal
        )
        
        config.preferredSymbolConfigurationForImage = .init(
            pointSize: 10,
            weight: .semibold
        )
        
        let view = UIButton(configuration: config)
        
        return view
    }()
        
    // MARK: - Setup methods
    
    func setup(with name: String) {
        subviews.forEach { $0.removeFromSuperview() }
        
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.carrotOrange.cgColor
        
        self.nameLabel.text = name
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(nameLabel)
        addSubview(removeButton)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(12)
            
        }
        
        removeButton.snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(12)
        }
    }
}
