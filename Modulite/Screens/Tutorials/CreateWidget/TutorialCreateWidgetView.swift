//
//  TutorialCreateWidgetView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit
import SnapKit

class TutorialCreateWidgetView: UIScrollView {
    
    private let contentView = UIView()
    
    // MARK: - Subviews
    
    private(set) lazy var titleLabel = TutorialLargeTitleLabel(
        textLocalizedKey: .tutorialCenterHowToCreateWidget
    )
    
    private(set) var changeModulesTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialEditWidgetHowToChangeModulesTitle
    )
    
    private(set) var changeModulesDescription = TutorialTextParagraphLabel(
        textLocalizedKey: .tutorialEditWidgetHowToChangeModulesDescription
    )
    
    private(set) lazy var changeModulesImage: UIImageView = {
        let view = UIImageView(image: .tutorialChangeModulePositions)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var editStyleAndColorTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialEditWidgetHowToEditStyleAndColorTitle
    )
    
    private(set) var editStyleAndColorDescriptionStack: UIStackView = {
        let text1 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialEditWidgetHowToEditStyleAndColorDescription1
        )
        
        let text2 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialEditWidgetHowToEditStyleAndColorDescription2
        )
        
        let text3 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialEditWidgetHowToEditStyleAndColorDescription3
        )
        
        let stack = UIStackView(arrangedSubviews: [text1, text2, text3])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private(set) lazy var editStyleAndColorImage: UIImageView = {
        let view = UIImageView(image: .tutorialEditModuleStyleAnd)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var switchModuleTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialEditWidgetHowToSwitchModuleTitle
    )
    
    private(set) var switchModuleDescription = TutorialMultiParagraphLabel(
        localizedKeys: [
            .tutorialEditWidgetHowToSwitchModuleDescription1,
            .tutorialEditWidgetHowToSwitchModuleDescription2
        ]
    )
    
    private(set) var changeAppsLabel = TutorialTitleLabel(
        textLocalizedKey: .tutorialEditWidgetHowToChangeAppTitle
    )
    
    private(set) var changeAppsDescription = TutorialMultiParagraphLabel(
        localizedKeys: [
            .tutorialEditWidgetHowToChangeAppDescription1,
            .tutorialEditWidgetHowToChangeAppDescription2,
            .tutorialEditWidgetHowToChangeAppDescription3
        ]
    )
    
    private(set) var blankModulesTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialEditWidgetWhyBlankButtonTitle
    )
    
    private(set) var blankModulesDescription = TutorialMultiParagraphLabel(
        localizedKeys: [
            .tutorialEditWidgetWhyBlankButtonDescription1,
            .tutorialEditWidgetWhyBlankButtonDescription2
        ]
    )
    
    private(set) var needHelpTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialEditWidgetNeedHelpTitle
    )
    
    private(set) var needHelpDescription = TutorialTextParagraphLabel(
        textLocalizedKey: .tutorialEditWidgetNeedHelpDescription
    )
    
    private(set) lazy var needHelpButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        let attributedString = NSMutableAttributedString(
            string: .localized(for: TutorialWidgetConfigurationTexts.tutorialEditWidgetNeedHelpButtonText),
            attributes: [
                .font: UIFont(textStyle: .body, weight: .semibold),
                .foregroundColor: UIColor.blueberry,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.blueberry
            ]
        )
        
        config.titleAlignment = .leading
        config.attributedTitle = AttributedString(attributedString)
        
        let view = UIButton(configuration: config)
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        backgroundColor = .whiteTurnip
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subview Setup
    
    private func addSubviews() {
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(changeModulesTitle)
        contentView.addSubview(changeModulesDescription)
        contentView.addSubview(changeModulesImage)
        
        contentView.addSubview(editStyleAndColorTitle)
        contentView.addSubview(editStyleAndColorDescriptionStack)
        contentView.addSubview(editStyleAndColorImage)
        
        contentView.addSubview(switchModuleTitle)
        contentView.addSubview(switchModuleDescription)
        
        contentView.addSubview(changeAppsLabel)
        contentView.addSubview(changeAppsDescription)
        
        contentView.addSubview(blankModulesTitle)
        contentView.addSubview(blankModulesDescription)
        
        contentView.addSubview(needHelpTitle)
        contentView.addSubview(needHelpDescription)
        contentView.addSubview(needHelpButton)
    }
    
    // MARK: - Constraints Setup
    
    private func setupConstraints() {
        setupContentViewConstraints()
        setupChangeModulesConstraints()
        setupEditStyleAndColorConstraints()
        setupSwitchModuleConstraints()
        setupChangeAppsConstraints()
        setupBlankModulesConstraints()
        setupNeedHelpConstraints()
    }
    
    private func setupContentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 0, left: 24, bottom: 0, right: -24)
            )
            make.width.equalToSuperview().offset(-48)
        }
    }
    
    private func setupChangeModulesConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        changeModulesTitle.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        changeModulesDescription.snp.makeConstraints { make in
            make.top.equalTo(changeModulesTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        changeModulesImage.snp.makeConstraints { make in
            make.top.equalTo(changeModulesDescription.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(124)
        }
    }
    
    private func setupEditStyleAndColorConstraints() {
        editStyleAndColorTitle.snp.makeConstraints { make in
            make.top.equalTo(changeModulesImage.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
        }
        
        editStyleAndColorDescriptionStack.snp.makeConstraints { make in
            make.top.equalTo(editStyleAndColorTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        editStyleAndColorImage.snp.makeConstraints { make in
            make.top.equalTo(editStyleAndColorDescriptionStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupSwitchModuleConstraints() {
        switchModuleTitle.snp.makeConstraints { make in
            make.top.equalTo(editStyleAndColorImage.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        switchModuleDescription.snp.makeConstraints { make in
            make.top.equalTo(switchModuleTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupChangeAppsConstraints() {
        changeAppsLabel.snp.makeConstraints { make in
            make.top.equalTo(switchModuleDescription.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        changeAppsDescription.snp.makeConstraints { make in
            make.top.equalTo(changeAppsLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupBlankModulesConstraints() {
        blankModulesTitle.snp.makeConstraints { make in
            make.top.equalTo(changeAppsDescription.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        blankModulesDescription.snp.makeConstraints { make in
            make.top.equalTo(blankModulesTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupNeedHelpConstraints() {
        needHelpTitle.snp.makeConstraints { make in
            make.top.equalTo(blankModulesDescription.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        needHelpDescription.snp.makeConstraints { make in
            make.top.equalTo(needHelpTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        needHelpButton.snp.makeConstraints { make in
            make.top.equalTo(needHelpDescription.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
