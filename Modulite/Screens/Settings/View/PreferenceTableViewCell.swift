//
//  PreferenceTableViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import UIKit
import SnapKit

class PreferenceTableViewCell: UITableViewCell {
    static let reuseId = "PreferenceTableViewCell"
    
    // MARK: - Properties
    private let topSeparator = UIView()
    private let bottomSeparator = UIView()
    
    private(set) lazy var iconImageContainer = UIView()
    
    private(set) lazy var iconImage: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private(set) lazy var preferenceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .semibold)
        
        return label
    }()
    
    private(set) lazy var chevronRight: UIImageView = {
        let view = UIImageView(
            image: UIImage(systemName: "chevron.right")!
                .withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
                .withConfiguration(
                    UIImage.SymbolConfiguration(
                        pointSize: 16,
                        weight: .regular
                    )
                )
        )
        
        return view
    }()
    
    // MARK: - Setup Methods
    func setup(
        sfSymbolName: String,
        iconColor: UIColor,
        title: String,
        hasBottomSeparator: Bool
    ) {
        subviews.forEach { $0.removeFromSuperview() }
        let image = UIImage(systemName: sfSymbolName)!
            .withTintColor(iconColor, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    pointSize: 21,
                    weight: .regular
                )
            )
        
        iconImage.image = image
        preferenceTitle.text = title
        
        addSubviews()
        setupConstraints()
        setupSeparators(hasBottomSeparator: hasBottomSeparator)
    }
    
    private func setupSeparators(hasBottomSeparator: Bool) {
        topSeparator.backgroundColor = .potatoYellow
        bottomSeparator.backgroundColor = .potatoYellow
        
        contentView.addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        guard hasBottomSeparator else { return }
        
        contentView.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    private func addSubviews() {
        addSubview(iconImageContainer)
        iconImageContainer.addSubview(iconImage)
        addSubview(preferenceTitle)
        addSubview(chevronRight)
    }
    
    private func setupConstraints() {
        iconImageContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
        
        iconImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        preferenceTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageContainer.snp.right).offset(8)
        }
        
        chevronRight.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
        }
    }
}
