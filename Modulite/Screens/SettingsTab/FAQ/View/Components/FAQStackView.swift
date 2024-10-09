//
//  FAQStackView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit

class FAQStackView: UIStackView {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 16
        distribution = .equalSpacing
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    func populateQuestions(with questions: [FAQQuestionModel]) {
        setupQuestions(questions)
    }
    
    private func setupQuestions(_ questions: [FAQQuestionModel]) {
        questions.forEach { question in
            let questionView = FAQQuestionAndAnswerView()
            questionView.setupQuestionAndAnswer(question: question)
            addArrangedSubview(questionView)
        }
    }
}
