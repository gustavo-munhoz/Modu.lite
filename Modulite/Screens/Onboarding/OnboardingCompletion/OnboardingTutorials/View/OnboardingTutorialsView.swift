//
//  OnboardingTutorialsView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit
import SnapKit

class OnboardingTutorialsView: UIView {
    
    // MARK: - Subviews
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .fiestaGreen
        view.textAlignment = .center
        view.font = UIFont(textStyle: .largeTitle, weight: .bold)
        view.numberOfLines = -1
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont(textStyle: .body, weight: .bold)
        view.numberOfLines = -1
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    
    private(set) lazy var numbereredTextBox = OnboardingNumberedTextBox()
    
    private(set) lazy var wallpaperTutorialButton = OnboardingTutorialButton()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        backgroundColor = .whiteTurnip
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(numbereredTextBox)
        addSubview(wallpaperTutorialButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
        }
        
        numbereredTextBox.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        wallpaperTutorialButton.snp.makeConstraints { make in
            make.top.equalTo(numbereredTextBox.snp.bottom).offset(24)
            make.left.right.equalTo(numbereredTextBox)
        }
    }
    
    func setup() {
        titleLabel.text = .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperTitle)
        subtitleLabel.text = .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperSubtitle)
        
        let highlightedText = CustomizedTextFactory.createTextWithAsterisk(
            with: .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperHighlightedText),
            asteriskRect: CGRect(x: 0, y: -2.5, width: 17, height: 17),
            textStyle: .body,
            symbolicTraits: .traitBold,
            paragraphHeadIndent: 0
        )
        
        numbereredTextBox.setup(
            number: 1,
            highlightedText: highlightedText,
            text: .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperNumberBoxText)
        )
    }
}
