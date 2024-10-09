//
//  TutorialEditWidgetView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit
import SnapKit

class TutorialEditWidgetView: UIScrollView {
    
    private let contentView = UIView()
    
    // MARK: - Subviews
    
    private(set) var titleLabel = TutorialLargeTitleLabel(
        textLocalizedKey: .tutorialCenterHowToEditOrDeleteWidget
    )
    
    private(set) var editWidgetsTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialEditingWidgetTitle
    )
    
    private(set) var editWidgetsDescription1 = TutorialTextParagraphLabel(
        textLocalizedKey: .tutorialEditingWidgetDescription1
    )
    
    private(set) lazy var editWidgetsImage1: UIImageView = {
        let view = UIImageView(image: .tutorialEditWidget1)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var editWidgetsStackDescription2: UIStackView = {
        let text1 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialEditingWidgetDescription2
        )
        
        let text2 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialEditingWidgetDescription2Step1
        )
        
        let text3 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialEditingWidgetDescription2Step2
        )
        
        let stack = UIStackView(arrangedSubviews: [text1, text2, text3])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private(set) lazy var editWidgetsImage2: UIImageView = {
        let view = UIImageView(image: .tutorialEditWidget2)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private(set) var deleteWidgetsTitle = TutorialTitleLabel(
        textLocalizedKey: .tutorialDeletingWidgetTitle
    )
    
    private(set) var deleteWidgetsStackDescription1: UIStackView = {
        let text1 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialDeletingWidgetDescription1Step1
        )
        
        let text2 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialDeletingWidgetDescription1Step2
        )
        
        let stack = UIStackView(arrangedSubviews: [text1, text2])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private(set) lazy var deleteWidgetsImage1: UIImageView = {
        let view = UIImageView(image: .tutorialDeleteWidget1)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) var deleteWidgetsDescription2 = TutorialTextParagraphLabel(
        textLocalizedKey: .tutorialDeletingWidgetDescription2
    )
    
    private(set) var deleteWidgetsStackDescription2: UIStackView = {
        let text1 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialDeletingWidgetDescription2Step1
        )
        
        let text2 = TutorialTextParagraphLabel(
            textLocalizedKey: .tutorialDeletingWidgetDescription2Step2
        )
        
        let stack = UIStackView(arrangedSubviews: [text1, text2])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private(set) lazy var deleteWidgetsImage2: UIImageView = {
        let view = UIImageView(image: .tutorialDeleteWidget2)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
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
        contentView.addSubview(editWidgetsTitle)
        contentView.addSubview(editWidgetsDescription1)
        contentView.addSubview(editWidgetsImage1)
        contentView.addSubview(editWidgetsStackDescription2)
        contentView.addSubview(editWidgetsImage2)
        
        contentView.addSubview(deleteWidgetsTitle)
        contentView.addSubview(deleteWidgetsStackDescription1)
        contentView.addSubview(deleteWidgetsImage1)
        contentView.addSubview(deleteWidgetsDescription2)
        contentView.addSubview(deleteWidgetsStackDescription2)
        contentView.addSubview(deleteWidgetsImage2)
    }
    
    private func setupConstraints() {
        setupContentViewConstraints()
        setupEditWidgetsSectionConstraints()
        setupDeleteWidgetsSectionConstraints()
    }

    private func setupContentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 0, left: 24, bottom: 0, right: -24)
            )
            make.width.equalToSuperview().offset(-48)
        }
    }

    private func setupEditWidgetsSectionConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        editWidgetsTitle.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        editWidgetsDescription1.snp.makeConstraints { make in
            make.top.equalTo(editWidgetsTitle.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        editWidgetsImage1.snp.makeConstraints { make in
            make.top.equalTo(editWidgetsDescription1.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        editWidgetsStackDescription2.snp.makeConstraints { make in
            make.top.equalTo(editWidgetsImage1.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        editWidgetsImage2.snp.makeConstraints { make in
            make.top.equalTo(editWidgetsStackDescription2.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
    }

    private func setupDeleteWidgetsSectionConstraints() {
        deleteWidgetsTitle.snp.makeConstraints { make in
            make.top.equalTo(editWidgetsImage2.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        deleteWidgetsStackDescription1.snp.makeConstraints { make in
            make.top.equalTo(deleteWidgetsTitle.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        deleteWidgetsImage1.snp.makeConstraints { make in
            make.top.equalTo(deleteWidgetsStackDescription1.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        deleteWidgetsDescription2.snp.makeConstraints { make in
            make.top.equalTo(deleteWidgetsImage1.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        deleteWidgetsStackDescription2.snp.makeConstraints { make in
            make.top.equalTo(deleteWidgetsDescription2.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        deleteWidgetsImage2.snp.makeConstraints { make in
            make.top.equalTo(deleteWidgetsStackDescription2.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
