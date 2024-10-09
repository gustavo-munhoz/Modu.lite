//
//  FAQView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit
import SnapKit

class FAQView: UIScrollView {
    // MARK: - Subviews
    private let contentView = UIView()
    
    private(set) lazy var summaryHeaderTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .title2, weight: .bold)
        label.text = .localized(for: FAQLocalizedTexts.faqViewSummaryTitle)
        
        return label
    }()
    
    private let summaryStackView = FAQSummaryStackView()
    private(set) var questionsStackView = FAQStackView()
    
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
    
    // MARK: - Setup Methods
    func setQuestions(to questions: [FAQQuestionModel]) {
        questionsStackView.populateQuestions(with: questions)
        summaryStackView.setupSummaryButtons(
            for: questions,
            target: self,
            action: #selector(scrollToQuestion(_:))
        )
    }
    
    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(summaryHeaderTitle)
        contentView.addSubview(summaryStackView)
        contentView.addSubview(questionsStackView)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
            )
            make.width.equalToSuperview().offset(-48)
        }
        
        summaryHeaderTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview()
        }
        
        summaryStackView.snp.makeConstraints { make in
            make.top.equalTo(summaryHeaderTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        questionsStackView.snp.makeConstraints { make in
            make.top.equalTo(summaryStackView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // MARK: - Actions
    @objc private func scrollToQuestion(_ sender: UIButton) {
        let index = sender.tag
        guard index < questionsStackView.arrangedSubviews.count else { return }
        
        let targetView = questionsStackView.arrangedSubviews[index]
        let targetFrame = convert(targetView.frame, from: questionsStackView)
        
        var offset = CGPoint(x: contentOffset.x, y: targetFrame.origin.y)
                
        offset.y = max(0, offset.y - targetFrame.height/2)

        setContentOffset(offset, animated: true)
    }
}
