//
//  FAQQuestionAndAnswerView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit
import SnapKit

class FAQQuestionAndAnswerView: UIView {
    
    // MARK: - Subviews
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .title3, weight: .bold)
        label.textColor = .carrotOrange
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func addSubviews() {
        addSubview(questionLabel)
        addSubview(answerLabel)
    }
    
    private func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configuration Method
    
    func configure(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
    }
}

extension FAQQuestionAndAnswerView {
    func setupQuestionAndAnswer(question: FAQQuestionModel) {
        questionLabel.text = question.question
        answerLabel.text = question.answer
    }
}
