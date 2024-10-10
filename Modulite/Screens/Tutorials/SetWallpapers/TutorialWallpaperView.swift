//
//  TutorialWallpaperView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/10/24.
//

import UIKit
import SnapKit

class TutorialWallpaperView: UIScrollView {
    
    private let contentView = UIView()
    
    // MARK: - Subviews
    
    private(set) lazy var titleLabel = TutorialLargeTitleLabel(
        textLocalizedKey: .tutorialCenterSetWallpapers
    )
    
    private(set) var setWallpaperDescription = TutorialTextParagraphLabel(
        textLocalizedKey: .tutorialWallpaperHowToSetDescription
    )
    
    private(set) var setWallpaperFirstSixSteps: UIStackView = {
        let step1 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep1
        )
        
        let step2 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep2
        )
        
        let step3 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep3
        )
        
        let step4 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep4
        )
        
        let step5 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep5
        )
        
        let step6 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep6
        )
        
        let stack = UIStackView(arrangedSubviews: [step1, step2, step3, step4, step5, step6])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    private(set) lazy var setWallpaperFirstSixStepsImage: UIImageView = {
        let view = UIImageView(image: .tutorialWallpaperSteps1To6)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) var setWallpaperLastThreeSteps: UIStackView = {
        let step7 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep7
        )
        
        let step8 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep8
        )
        
        let step9 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialWallpaperHowToSetStep9
        )
        
        let stack = UIStackView(arrangedSubviews: [step7, step8, step9])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    private(set) lazy var setWallpaperLastThreeStepsImage: UIImageView = {
        let view = UIImageView(image: .tutorialWallpaperSteps7To9)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) var needHelpTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialWallpaperNeedHelpTitle
    )
    
    private(set) var needHelpDescription = TutorialTextParagraphLabel(
        textLocalizedKey: .tutorialWallpaperNeedHelpDescription
    )
    
    private(set) lazy var needHelpButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let attributedString = NSMutableAttributedString(
            string: .localized(
                for: TutorialWidgetConfigurationTexts.tutorialWallpaperNeedHelpButtonText
            ),
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
    
    private func addSubviews() {
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
                
        contentView.addSubview(setWallpaperDescription)
        contentView.addSubview(setWallpaperFirstSixSteps)
        contentView.addSubview(setWallpaperFirstSixStepsImage)
        contentView.addSubview(setWallpaperLastThreeSteps)
        contentView.addSubview(setWallpaperLastThreeStepsImage)
        contentView.addSubview(needHelpTitle)
        contentView.addSubview(needHelpDescription)
        contentView.addSubview(needHelpButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 0, left: 24, bottom: 0, right: -24)
            )
            make.width.equalToSuperview().offset(-48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        setWallpaperDescription.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        setWallpaperFirstSixSteps.snp.makeConstraints { make in
            make.top.equalTo(setWallpaperDescription.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        setWallpaperFirstSixStepsImage.snp.makeConstraints { make in
            make.top.equalTo(setWallpaperFirstSixSteps.snp.bottom).offset(24)
            make.centerX.width.equalToSuperview()
        }
        
        setWallpaperLastThreeSteps.snp.makeConstraints { make in
            make.top.equalTo(setWallpaperFirstSixStepsImage.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        setWallpaperLastThreeStepsImage.snp.makeConstraints { make in
            make.top.equalTo(setWallpaperLastThreeSteps.snp.bottom).offset(24)
            make.centerX.width.equalToSuperview()
        }
        
        needHelpTitle.snp.makeConstraints { make in
            make.top.equalTo(setWallpaperLastThreeStepsImage.snp.bottom).offset(24)
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