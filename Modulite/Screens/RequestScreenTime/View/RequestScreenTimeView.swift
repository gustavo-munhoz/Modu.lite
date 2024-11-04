//
//  RequestScreenTimeView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 18/10/24.
//

import UIKit
import SnapKit

enum ScreenTimeRequestType {
    case usage
    case appBlocking
}

class RequestScreenTimeView: UIView {
    
    var requestType: ScreenTimeRequestType = .usage
    
    private let gradientLayer = CAGradientLayer()
    
    private var titleText: RequestScreenTimeTexts {
        requestType == .usage ? .requestScreenTimeUsageTitle : .requestScreenTimeAppBlockTitle
    }
    
    private var subtitleText: RequestScreenTimeTexts {
        requestType == .usage ? .requestScreenTimeUsageSubtitle : .requestScreenTimeAppBlockSubtitle
    }
    
    var onConnectButtonPress: (() -> Void)?
    var onDismissButtonPress: (() -> Void)?
    
    // MARK: - Subviews
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.attributedText = NSAttributedString(
            string: .localized(for: titleText),
            attributes: [
                .font: UIFont.spaceGrotesk(textStyle: .largeTitle, weight: .bold),
                .foregroundColor: UIColor.black,
                .kern: -0.4
            ]
        )
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .headline, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.text = .localized(for: subtitleText)
        label.textColor = .black
        return label
    }()
    
    private(set) lazy var screenTimeVsModuliteImage: UIImageView = {
        let imageView = UIImageView(image: .screenTimeVsModulite)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private(set) lazy var footnoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        let regularText = String.localized(for: RequestScreenTimeTexts.requestScreenTimeFootnoteRegular)
        let boldText = String.localized(for: RequestScreenTimeTexts.requestScreenTimeFootnoteBold)
        let attributedString = NSMutableAttributedString(
            string: regularText,
            attributes: [
                .font: UIFont(textStyle: .footnote, symbolicTraits: .traitItalic) as Any,
                .foregroundColor: UIColor.black
            ]
        )
        let boldAttributedString = NSAttributedString(
            string: boldText,
            attributes: [
                .font: UIFont(textStyle: .footnote, weight: .bold, italic: true) as Any,
                .foregroundColor: UIColor.black
            ]
        )
        attributedString.append(boldAttributedString)
        label.attributedText = attributedString
        return label
    }()
    
    private(set) lazy var connectButton: UIButton = {
        let button = ButtonFactory.mediumButton(
            titleKey: RequestScreenTimeTexts.requestScreenConnectButtonTitle,
            font: .spaceGrotesk(textStyle: .title2, weight: .bold),
            backgroundColor: .fiestaGreen.resolvedColor(with: .init(userInterfaceStyle: .light))
        )
        button.addTarget(self, action: #selector(didPressConnectButton), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var dismissButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            .localized(for: RequestScreenTimeTexts.requestScreenDismissButtonTitle),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .semibold),
                .foregroundColor: UIColor.charcoalGray,
                .underlineColor: UIColor.charcoalGray,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ])
        )
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didPressDismissButton), for: .touchUpInside)
        button.configurationUpdateHandler = { btn in
            btn.alpha = btn.state == .highlighted ? 0.6 : 1
        }
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientBackground()
        setupScrollView()
        addSubviews()
        setupConstraints()
        scrollView.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientBackground()
        setupScrollView()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Actions
    @objc private func didPressConnectButton() {
        onConnectButtonPress?()
    }
    
    @objc private func didPressDismissButton() {
        onDismissButtonPress?()
    }
    
    // MARK: - Setup Methods
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func setRequestType(to type: ScreenTimeRequestType) {
        requestType = type
        titleLabel.text = .localized(for: titleText)
        subtitleLabel.text = .localized(for: subtitleText)
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(screenTimeVsModuliteImage)
        contentView.addSubview(footnoteLabel)
        contentView.addSubview(connectButton)
        contentView.addSubview(dismissButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.right.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.left.right.equalToSuperview().inset(24)
        }
        
        screenTimeVsModuliteImage.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(48)
            make.height.equalTo(132)
            make.centerX.equalToSuperview()
        }
        
        footnoteLabel.snp.makeConstraints { make in
            make.top.equalTo(screenTimeVsModuliteImage.snp.bottom).offset(48)
            make.left.right.equalToSuperview().inset(24)
        }
        
        connectButton.snp.remakeConstraints { make in
            make.top.equalTo(footnoteLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(connectButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupGradientBackground() {
        let gradient = Gradient.potato()
        gradientLayer.colors = gradient.colors
        gradientLayer.startPoint = gradient.startPoint
        gradientLayer.endPoint = gradient.endPoint
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
