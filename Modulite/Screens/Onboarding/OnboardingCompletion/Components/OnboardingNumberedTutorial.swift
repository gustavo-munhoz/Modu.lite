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
    
    // MARK: - Setup Methods
    func setup(
        number: Int,
        highlightedText: NSAttributedString? = nil,
        text: String
    ) {
        numberLabel.text = "\(number)"
        
        let completeText = NSMutableAttributedString("")
        
        if let highlightedText {
            completeText.append(highlightedText)
            completeText.append(NSAttributedString(" "))
        }
        
        completeText.append(NSAttributedString(string: text))
        
        textLabel.attributedText = completeText
        
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
