//
//  OnboardingNumberedTutorial.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit
import SnapKit

class OnboardingNumberedTutorial: UIView {
    
    var onTutorialButtonPressed: (() -> Void)?
    var onRedirectButtonPressed: (() -> Void)?
    
    // MARK: - Subviews
    private(set) lazy var numberLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .lemonYellow
        view.textColor = .black
        view.font = UIFont(textStyle: .title1, weight: .bold)
        view.textAlignment = .center
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private(set) lazy var textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = -1
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    
    private(set) lazy var tutorialButton: UIButton = {
        let view = ButtonFactory.mediumButton(
            titleKey: OnboardingLocalizedTexts.onboardingHowDoIDoThat,
            font: UIFont(textStyle: .body, weight: .bold),
            image: UIImage(systemName: "info.circle"),
            imagePointSize: 16,
            backgroundColor: .systemGray,
            size: CGSize(width: 240, height: 45)
        )
        
        view.addTarget(self, action: #selector(didPressTutorial), for: .touchUpInside)
        
        return view
    }()
    
    private(set) var redirectButton: UIButton?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func didPressTutorial() {
        onTutorialButtonPressed?()
    }
    
    @objc private func didPressRedirect() {
        onRedirectButtonPressed?()
    }
    
    // MARK: - Setup Methods
    func setHasRedirectButton(title: String) {
        // For now will only work if it has tutorial button
        guard subviews.contains(tutorialButton) else { return }
        
        redirectButton = ButtonFactory.textLinkButton(
            text: title
        )
        
        redirectButton?.addTarget(self, action: #selector(didPressRedirect), for: .touchUpInside)
        redirectButton!.titleLabel?.text = title
        
        addSubview(redirectButton!)
        tutorialButton.snp.remakeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(45)
        }
        
        redirectButton!.snp.makeConstraints { make in
            make.top.equalTo(tutorialButton.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func setRemovesTutorialButton(_ remove: Bool) {
        guard remove else { return }
        
        tutorialButton.removeFromSuperview()
        textLabel.snp.remakeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    func setup(number: Int, attributedText: NSAttributedString) {
        numberLabel.text = "\(number)"
        textLabel.attributedText = attributedText
        
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.lemonYellow.cgColor
    }
    
    private func addSubviews() {
        addSubview(numberLabel)
        addSubview(textLabel)
        addSubview(tutorialButton)
    }
    
    private func setupConstraints() {
        numberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(45)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(24)
        }
        
        tutorialButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
