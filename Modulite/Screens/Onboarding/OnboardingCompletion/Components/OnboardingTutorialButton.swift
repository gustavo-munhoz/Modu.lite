//
//  OnboardingTutorialButton.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit
import SnapKit

class OnboardingTutorialButton: UIView {
    
    // MARK: - Subviews
    
    private lazy var ellipsisImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "ellipsis"))
        imageView.tintColor = .charcoalGray
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        
        return imageView
    }()
    
    private(set) lazy var collapseButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: "info.circle")?
            .withTintColor(.charcoalGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold))
        
        config.imagePlacement = .leading
        config.imagePadding = 12
        
        config.attributedTitle = AttributedString(
            .localized(for: OnboardingLocalizedTexts.onboardingHowDoIDoThat),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .semibold),
                .foregroundColor: UIColor.charcoalGray
            ])
        )
        
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        
        button.configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                button.alpha = button.state == .highlighted ? 0.5 : 1
            }
        }
        
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupBorder() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.borderWidth = 2
        clipsToBounds = true
    }
    
    private func addSubviews() {
        addSubview(collapseButton)
        addSubview(ellipsisImage)
    }
    
    private func setupConstraints() {
        collapseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalTo(ellipsisImage.snp.left)
        }
        
        ellipsisImage.snp.makeConstraints { make in
            make.centerY.equalTo(collapseButton)
            make.right.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Actions
    
}
