//
//  ComingSoonBadge.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 10/10/24.
//

import UIKit
import SnapKit

class ComingSoonBadge: UIView {
    
    // MARK: - Subviews
    private(set) lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.preferredSymbolConfiguration = .init(pointSize: 67)
        
        return view
    }()
    
    private(set) lazy var comingSoonLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: .comingSoonTitle).dropLast(3).capitalized
        label.font = UIFont(textStyle: .title3, weight: .semibold, italic: true)
        label.textAlignment = .center
        
        return label
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .largeTitle, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private(set) lazy var featureDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .regular)
        label.textAlignment = .center
        label.textColor = .systemGray
        
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    func setup(
        iconName: String,
        color: UIColor,
        titleKey: LocalizedKeyProtocol,
        descriptionKey: LocalizedKeyProtocol
    ) {
        let image = UIImage(systemName: iconName)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
        
        iconImageView.image = image
        titleLabel.text = .localized(for: titleKey)
        featureDescriptionLabel.text = .localized(for: descriptionKey)
    }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(comingSoonLabel)
        addSubview(titleLabel)
        addSubview(featureDescriptionLabel)
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.centerY).offset(-100)
            make.width.height.equalTo(67)
            make.centerX.equalToSuperview()
        }
        
        comingSoonLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(comingSoonLabel.snp.bottom).offset(24)
            make.left.right.equalTo(comingSoonLabel)
        }
        
        featureDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalTo(titleLabel)
        }
    }
}
