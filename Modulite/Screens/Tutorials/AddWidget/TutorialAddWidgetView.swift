//
//  TutorialAddWidgetView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit
import SnapKit

class TutorialAddWidgetView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - Subviews
    
    private(set) var titleLabel = TutorialLargeTitleLabel(
        textLocalizedKey: .tutorialCenterAddWidgetsToHomeScreen
    )
    
    private(set) var firstTwoStepsStack = TutorialStepsStackView(
        localizedKeys: [
            .tutorialAddWidgetStep1,
            .tutorialAddWidgetStep2
        ]
    )
    
    private(set) lazy var addWidgetImage1: UIImageView = {
        let view = UIImageView(image: .addWidgetImage1And2)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var lastThreeStepsStack = TutorialStepsStackView(
        localizedKeys: [
            .tutorialAddWidgetStep3,
            .tutorialAddWidgetStep4,
            .tutorialAddWidgetStep5
        ]
    )
    
    private(set) lazy var addWidgetImage2: UIImageView = {
        let view = UIImageView(image: .addWidgetImage3To5)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var needHelpTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialAddWidgetNeedHelpTitle
    )
    
    private(set) var needHelpDescription = TutorialTextParagraphLabel(
        textLocalizedKey: .tutorialAddWidgetNeedHelpDescription
    )
    
    private(set) lazy var needHelpButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let attributedString = NSMutableAttributedString(
            string: .localized(for: TutorialWidgetConfigurationTexts.tutorialAddWidgetNeedHelpButton),
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
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(firstTwoStepsStack)
        contentView.addSubview(addWidgetImage1)
        contentView.addSubview(lastThreeStepsStack)
        contentView.addSubview(addWidgetImage2)
        contentView.addSubview(needHelpTitle)
        contentView.addSubview(needHelpDescription)
        contentView.addSubview(needHelpButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        
        firstTwoStepsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        
        addWidgetImage1.snp.makeConstraints { make in
            make.top.equalTo(firstTwoStepsStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        lastThreeStepsStack.snp.makeConstraints { make in
            make.top.equalTo(addWidgetImage1.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        addWidgetImage2.snp.makeConstraints { make in
            make.top.equalTo(lastThreeStepsStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        needHelpTitle.snp.makeConstraints { make in
            make.top.equalTo(addWidgetImage2.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        needHelpDescription.snp.makeConstraints { make in
            make.top.equalTo(needHelpTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }
        
        needHelpButton.snp.makeConstraints { make in
            make.top.equalTo(needHelpDescription.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
