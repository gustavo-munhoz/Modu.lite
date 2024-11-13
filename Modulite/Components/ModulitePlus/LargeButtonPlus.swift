//
//  LargeButtonPlus.swift
//  Modulite
//
//  Created by André Wozniack on 08/11/24.
//
import UIKit
import SnapKit

class LargeButtonPlus: UIView {
    
    // MARK: - Properties
    private(set) lazy var backgourndLabel: GradientLabelView = {
        let view = GradientLabelView(gradient: .ice())
        view.clipsToBounds = true
        view.layer.cornerRadius = 14.4
        return view
    }()
    
    private(set) lazy var moduliteLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "moduliteAppName")?.withConfiguration(
            UIImage.Configuration(
                traitCollection: UITraitCollection(userInterfaceStyle: .dark)
            )
        )
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    
    private(set) lazy var plusBadge: ModulitePlusSmallBadge = {
        let view = ModulitePlusSmallBadge()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 4
        return view
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
    
    private(set) lazy var upgradeButton: UIButton = {
        let view = ButtonFactory.mediumButton(
            titleKey: String.LocalizedKey.buttonUpgrandeNow,
            foregroundColor: .fiestaGreen,
            backgroundColor: .white
        )
        view.addTarget(self, action: #selector(upgradeTapped), for: .touchUpInside)
        return view
    }()

    private(set) lazy var startingAtLabel: UILabel = {
        let view = UILabel()
        
        let attributedText = NSAttributedString(
            string: .localized(for: .startingAtUSD999),
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont(
                    textStyle: .body,
                    weight: .semibold,
                    italic: true,
                    fontSize: 9
                )
            ]
        )
        
        view.attributedText = attributedText
        return view
    }()
    
    var onUpgradeButtonPress: (() -> Void)?

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
    
    private func addSubviews() {
        addSubview(backgourndLabel)
        addSubview(moduliteLogo)
        addSubview(plusBadge)
        addSubview(featuresStackView)
        addSubview(upgradeButton)
        addSubview(startingAtLabel)
    }
    
    private func setupConstraints() {
        backgourndLabel.snp.makeConstraints { make in
            make.width.equalTo(356)
            make.height.equalTo(280)
            make.centerY.centerX.equalToSuperview()
        }
        
        moduliteLogo.snp.makeConstraints { make in
            make.top.equalTo(backgourndLabel.snp.top).offset(35)
            make.left.equalTo(backgourndLabel.snp.left).inset(28)
            make.width.equalTo(167)
            make.height.equalTo(24)
        }
        
        plusBadge.snp.makeConstraints { make in
            make.left.equalTo(moduliteLogo.snp.right).offset(8)
            make.top.equalTo(moduliteLogo)
        }
        
        featuresStackView.snp.makeConstraints { make in
            make.top.equalTo(moduliteLogo.snp.bottom).offset(20)
            make.left.equalTo(backgourndLabel.snp.left).inset(28)
            make.right.equalTo(backgourndLabel.snp.right).inset(28)
        }
        
        upgradeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(featuresStackView.snp.bottom).offset(20)
        }
        
        startingAtLabel.snp.makeConstraints { make in
            make.top.equalTo(upgradeButton.snp.bottom).offset(8)
            make.centerX.equalTo(backgourndLabel)
            make.bottom.equalToSuperview().offset(-24)
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
    
    @objc func upgradeTapped() {
        onUpgradeButtonPress?()
    }
}

#Preview {
    LargeButtonPlus()
}
