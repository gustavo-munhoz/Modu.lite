//
//  ComingSoonView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 10/10/24.
//

import UIKit
import SnapKit

class ComingSoonView: UIView {
    
    // MARK: - Subviews
    private(set) lazy var circularImageView: ComingSoonCircularIconView = {
        let view = ComingSoonCircularIconView()
        
        return view
    }()
    
    private(set) lazy var comingSoonLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: .comingSoonTitle).dropLast().capitalized
        label.font = UIFont(textStyle: .title3, weight: .semibold, italic: true)
        label.textAlignment = .center
        
        return label
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .title1, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        
        return label
    }()
    
    private(set) lazy var featureDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .regular)
        
        label.textAlignment = .center
        label.textColor = .systemGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        
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
        titleKey: ComingSoonLocalizedTexts,
        descriptionKey: ComingSoonLocalizedTexts
    ) {
        let image = UIImage(systemName: iconName)!
            .withTintColor(color, renderingMode: .alwaysOriginal)
                
        circularImageView.setup(with: image, color: color)
        comingSoonLabel.textColor = color
        titleLabel.text = .localized(for: titleKey)
        featureDescriptionLabel.text = .localized(for: descriptionKey)
    }
    
    private func addSubviews() {
        addSubview(circularImageView)
        addSubview(comingSoonLabel)
        addSubview(titleLabel)
        addSubview(featureDescriptionLabel)
    }
    
    private func setupConstraints() {
        circularImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.centerY).offset(-150)
            make.width.height.equalTo(67)
            make.centerX.equalToSuperview()
        }
        
        comingSoonLabel.snp.makeConstraints { make in
            make.top.equalTo(circularImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(55)
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
