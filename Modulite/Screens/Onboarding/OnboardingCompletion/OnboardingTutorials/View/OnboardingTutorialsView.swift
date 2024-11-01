//
//  OnboardingTutorialsView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit
import SnapKit

class OnboardingTutorialsView: UIView {
    
    var onWallpaperTutorialPressed: (() -> Void)?
    var onWidgetTutorialPressed: (() -> Void)?
    
    // MARK: - Subviews
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .fiestaGreen
        view.textAlignment = .center
        view.font = UIFont(textStyle: .largeTitle, weight: .bold)
        view.numberOfLines = -1
        view.lineBreakMode = .byWordWrapping
        view.text = .localized(for: OnboardingLocalizedTexts.onboardingTutorialsTitle)
        
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont(textStyle: .body, weight: .bold)
        view.numberOfLines = -1
        view.lineBreakMode = .byWordWrapping
        view.text = .localized(for: OnboardingLocalizedTexts.onboardingTutorialsSubtitle)
        
        return view
    }()
    
    private(set) lazy var textBox1: OnboardingNumberedTutorial = {
        let view = OnboardingNumberedTutorial()
        
        let highlightedText = CustomizedTextFactory.createTextWithAsterisk(
            with: .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperHighlightedText),
            asteriskRect: CGRect(x: 0, y: -2.5, width: 17, height: 17),
            textStyle: .body,
            symbolicTraits: .traitBold,
            paragraphHeadIndent: 0
        )
        
        view.setup(
            number: 1,
            highlightedText: highlightedText,
            text: .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperNumberBoxText)
        )
        
        view.onTutorialButtonPressed = onWallpaperTutorialPressed
        
        return view
    }()
    
    private(set) lazy var textBox2: OnboardingNumberedTutorial = {
        let view = OnboardingNumberedTutorial()
        
        let highlightedText = CustomizedTextFactory.createTextWithAsterisk(
            with: .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperHighlightedText),
            asteriskRect: CGRect(x: 0, y: -2.5, width: 17, height: 17),
            textStyle: .body,
            symbolicTraits: .traitBold,
            paragraphHeadIndent: 0
        )
        
        view.setup(
            number: 2,
            highlightedText: highlightedText,
            text: .localized(for: OnboardingLocalizedTexts.onboardingSetWallpaperNumberBoxText)
        )

        view.onTutorialButtonPressed = onWidgetTutorialPressed
        
        return view
    }()

    private(set) lazy var allSetButton: UIButton = {
        let button = ButtonFactory.mediumButton(
            titleKey: OnboardingLocalizedTexts.onboardingTutorialsAllSet,
            image: UIImage(systemName: "arrow.right"),
            imagePlacement: .trailing
        )
        
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteTurnip
        setupScrollView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(textBox1)
        contentView.addSubview(textBox2)
        contentView.addSubview(allSetButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
        }
        
        textBox1.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        textBox2.snp.makeConstraints { make in
            make.top.equalTo(textBox1.snp.bottom).offset(24)
            make.left.right.equalTo(textBox1)
        }
        
        allSetButton.snp.makeConstraints { make in
            make.top.equalTo(textBox2.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }
    }
}
