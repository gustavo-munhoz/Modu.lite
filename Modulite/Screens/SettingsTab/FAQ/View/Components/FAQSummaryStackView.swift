//
//  FAQSummaryStackView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit

class FAQSummaryStackView: UIStackView {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .leading
        distribution = .equalSpacing
        spacing = 16
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Method
    func setupSummaryButtons(for questions: [FAQQuestionModel], target: Any?, action: Selector) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, question) in questions.enumerated() {
            var config = UIButton.Configuration.plain()
            
            let attributedString = NSMutableAttributedString(
                string: question.question,
                attributes: [
                    .font: UIFont(textStyle: .body, weight: .semibold),
                    .foregroundColor: UIColor.carrotOrange,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: UIColor.carrotOrange
                ]
            )
            
            config.titleAlignment = .leading
            config.titleLineBreakMode = .byWordWrapping
            config.attributedTitle = AttributedString(attributedString)
            config.contentInsets = .zero
            
            let button = UIButton(configuration: config)
            button.tag = index
            button.addTarget(target, action: action, for: .touchUpInside)
            
            button.configurationUpdateHandler = { btn in
                switch btn.state {
                case .highlighted:
                    btn.alpha = 0.5
                default:
                    btn.alpha = 1
                }
            }
            
            addArrangedSubview(button)
        }
    }
}
