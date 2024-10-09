//
//  HelpTopicsStackView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit

class HelpTopicsStackView: UIStackView {

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

    func populateTopics(with topics: [HelpTopicModel]) {
        setupTopics(topics)
    }
    
    private func setupTopics(_ topics: [HelpTopicModel]) {
        topics.forEach { topic in
            let topicView = HelpTopicView()
            topicView.setupTitleAndText(with: topic)
            addArrangedSubview(topicView)
        }
    }
}
