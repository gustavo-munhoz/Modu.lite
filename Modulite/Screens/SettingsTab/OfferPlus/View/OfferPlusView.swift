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
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        
        button.addTarget(
            self,
            action: #selector(closeTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: SettingsLocalizedTexts.offerPlusTitle)
        label.font = .spaceGrotesk(textStyle: .largeTitle, weight: .bold)
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
        stackView.spacing = 5
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
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        return stackView
    }
    
//    private lazy var oneMonthOptionView: UIView = {
//        let view = createOptionView(
//            title: "1 month",
//            price: "U$9.99",
//            subtext: "cancel at anytime",
//            highlight: false
//        )
//        return view
//    }()
//    
//    private lazy var twelveMonthOptionView: UIView = {
//        let view = createOptionView(
//            title: "12 months",
//            price: "U$99.90",
//            subtext: "approx. U$8.32/mo",
//            highlight: true
//        )
//        return view
//    }()
    
    private lazy var subscribeButton: UIButton = {
        let button = ButtonFactory.mediumButton(
            titleKey: SettingsLocalizedTexts.offerPlusSubscribeNow,
            foregroundColor: UIColor.carrotOrange,
            backgroundColor: UIColor.white
        )
        return button
    }()
    
    private lazy var noThanksButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localized(for: SettingsLocalizedTexts.offerPlusNoThnakYou), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(noThanksTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.15, green: 0.4, blue: 0.5, alpha: 1)
        addSubviews()
        setupConstraints()
        setupFeatures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func addSubviews() {
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(logoView)
        addSubview(featuresStackView)
//        addSubview(oneMonthOptionView)
//        addSubview(twelveMonthOptionView)
        addSubview(subscribeButton)
        addSubview(noThanksButton)
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(safeAreaLayoutGuide).offset(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(32)
            make.height.equalTo(96)
            make.centerX.equalToSuperview()
        }
        
        featuresStackView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
//        oneMonthOptionView.snp.makeConstraints { make in
//            make.top.equalTo(featuresStackView.snp.bottom).offset(24)
//            make.left.equalToSuperview().offset(32)
//            make.width.equalTo(120)
//        }
//        
//        twelveMonthOptionView.snp.makeConstraints { make in
//            make.top.equalTo(featuresStackView.snp.bottom).offset(24)
//            make.right.equalToSuperview().offset(-32)
//            make.width.equalTo(120)
//        }
        
//        subscribeButton.snp.makeConstraints { make in
//            make.top.equalTo(oneMonthOptionView.snp.bottom).offset(24)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(200)
//            make.height.equalTo(44)
//        }
        
        noThanksButton.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupFeatures() {
        let features = [
            ("infinity", "Unlimited widgets"),
            ("infinity", "Limitless auxiliary widgets"),
            ("lock", "Unlimited app blocking sessions"),
            ("square.on.square.dashed", "Many more skins options")
        ]
        
        for (iconName, text) in features {
            let itemView = createFeatureItem(iconName: iconName, text: text)
            featuresStackView.addArrangedSubview(itemView)
        }
    }

    private func createOptionView(title: String, price: String, subtext: String, highlight: Bool) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 8
        container.layer.borderWidth = highlight ? 2 : 1
        container.layer.borderColor = highlight ? UIColor.red.cgColor : UIColor.white.cgColor
        container.backgroundColor = highlight ? UIColor(red: 1, green: 0.5, blue: 0.3, alpha: 1) : .clear
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        
        let priceLabel = UILabel()
        priceLabel.text = price
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        priceLabel.textColor = .white
        
        let subtextLabel = UILabel()
        subtextLabel.text = subtext
        subtextLabel.font = UIFont.systemFont(ofSize: 10)
        subtextLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceLabel, subtextLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        container.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return container
    }
    
    // MARK: - Actions
    
    @objc func closeTapped() {
        // Ação para o botão de fechar
    }
    
    @objc func subscribeTapped() {
        // Ação para o botão de inscrição
    }
    
    @objc func noThanksTapped() {
        // Ação para o botão "No, thank you"
    }
}

#Preview {
    OfferPlusView()
}
