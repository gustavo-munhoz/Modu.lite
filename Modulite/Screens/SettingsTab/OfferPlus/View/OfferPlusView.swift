//
//  OfferPlusView.swift
//  Modulite
//
//  Created by André Wozniack on 13/11/24.
//

import UIKit
import SnapKit

class OfferPlusView: UIView {
    
    // MARK: - Properties
    enum SubscriptionOption: String {
        case monthly, year
    }
    
    var onSubscribe: ((_ option: SubscriptionOption) -> Void)?
    var onClose: (() -> Void)?
    private var selectedOption: SubscriptionOption?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: SettingsLocalizedTexts.offerPlusTitle)
        label.font = .spaceGrotesk(textStyle: .largeTitle, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moduliteLogoPlus")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowRadius = 4
        stackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        return stackView
    }()
    
    private func createFeatureItem(iconName: String, text: String) -> UIStackView {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = .white
        iconImageView.layer.shadowColor = UIColor.black.cgColor
        iconImageView.layer.shadowOpacity = 0.5
        iconImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        
        return stackView
    }
    
    private(set) lazy var monthSelectionView: SubscriptionMonthOptionView = {
        let view = SubscriptionMonthOptionView()
        view.onSelectionChanged = { [weak self] isSelected in
            if isSelected {
                self?.selectOption(.monthly)
            } else {
                self?.deselectOption()
            }
        }
        return view
    }()

    private(set) lazy var yearSelectionView: SubscriptionYearOptionView = {
        let view = SubscriptionYearOptionView()
        view.onSelectionChanged = { [weak self] isSelected in
            if isSelected {
                self?.selectOption(.year)
            } else {
                self?.deselectOption()
            }
        }
        return view
    }()
    
    private lazy var subscribeButton: UIButton = {
        let button = ButtonFactory.mediumButton(
            titleKey: SettingsLocalizedTexts.offerPlusSubscribeNow,
            foregroundColor: UIColor.lightGray,
            backgroundColor: UIColor.white
        )

        button.isEnabled = false
        button.addTarget(self, action: #selector(subscribeTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var noThanksButton: UIButton = {
        let button = ButtonFactory.textButton(
            text: .localized(for: SettingsLocalizedTexts.offerPlusNoThnakYou)
        )
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        return button
    }()
    
    private(set) lazy var gradientBackgroundView: GradientBackgroundView = {
        return GradientBackgroundView(gradient: Gradient.ice(direction: CGVector(dx: 0, dy: 1)))
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupFeatures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func addSubviews() {
        addSubview(gradientBackgroundView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(logoView)
        contentView.addSubview(featuresStackView)
        contentView.addSubview(monthSelectionView)
        contentView.addSubview(yearSelectionView)
        contentView.addSubview(subscribeButton)
        contentView.addSubview(noThanksButton)
    }
    
    private func setupConstraints() {
        
        gradientBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(16)
            make.left.equalTo(contentView).offset(30)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.height.equalTo(150)
        }
        
        featuresStackView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(16)
            make.left.equalTo(contentView).offset(30)
            make.right.equalTo(contentView).offset(-30)
        }
        
        monthSelectionView.snp.makeConstraints { make in
            make.top.equalTo(featuresStackView.snp.bottom).offset(20)
            make.left.equalTo(contentView).offset(30)
        }
        
        yearSelectionView.snp.makeConstraints { make in
            make.centerY.equalTo(monthSelectionView)
            make.left.equalTo(monthSelectionView.snp.right).offset(16)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(monthSelectionView.snp.bottom).offset(30)
            make.centerX.equalTo(contentView)
        }
        
        noThanksButton.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(20)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    private func setupFeatures() {
        let features: [(String, String)] = [
            ("rectangle.grid.3x2.fill", .localized(for: SettingsLocalizedTexts.offerPlusUnlimitedWidgets)),
            ("infinity", .localized(for: SettingsLocalizedTexts.offerplusLimitlessAuxiliaryWidgets)),
//            ("lock", .localized(for: SettingsLocalizedTexts.offerPLusUnlimitedAppBlockingSessions)),
            ("square.on.square.dashed", .localized(for: SettingsLocalizedTexts.offerPlusManyMoreSkinsOptions))
        ]
        
        for (iconName, text) in features {
            let itemView = createFeatureItem(iconName: iconName, text: text)
            featuresStackView.addArrangedSubview(itemView)
        }
    }

    // MARK: - Actions
    @objc func closeTapped() {
        onClose?()
    }
    
    @objc private func subscribeTapped() {
        guard let option = selectedOption else { return }
        onSubscribe?(option)
    }
    
    private func selectOption(_ option: SubscriptionOption) {
        selectedOption = option
        updateSubscribeButtonState()
    }
    
    private func deselectOption() {
        selectedOption = nil
        updateSubscribeButtonState()
    }
    
    private func updateSubscribeButtonState() {
        subscribeButton.isEnabled = selectedOption != nil
    }
}

#Preview {
    OfferPlusView()
}
