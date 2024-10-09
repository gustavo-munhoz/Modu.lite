//
//  HelpTopicView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit

class HelpTopicView: UIView {
    
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .title3, weight: .semibold)
        label.textColor = .blueberry
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let textLabel: UILabel = {
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
        addSubview(titleLabel)
        addSubview(textLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configuration Method
    
    func configure(question: String, answer: String) {
        titleLabel.text = question
        textLabel.text = answer
    }
}

extension HelpTopicView {
    func setupTitleAndText(with topic: HelpTopicModel) {
        titleLabel.text = topic.title
        textLabel.text = topic.text
    }
}
