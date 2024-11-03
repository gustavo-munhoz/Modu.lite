//
//  HelpView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit
import SnapKit

class HelpView: UIScrollView {
    // MARK: - Properties
    
    var onReportIssuesButtonTapped: (() -> Void)?
    
    // MARK: - Subviews
    
    private let contentView = UIView()
    
    private(set) var topicsStackView = HelpTopicsStackView()
    
    private(set) lazy var reportIssuesButton: UIButton = {
        let button = ButtonFactory.mediumButton(
            titleKey: HelpLocalizedTexts.helpViewEncounteredBugButton,
            font: .spaceGrotesk(textStyle: .title2, weight: .bold),
            image: UIImage(systemName: "envelope"),
            backgroundColor: .blueberry
        )

        button.addTarget(self, action: #selector(reportIssuesButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private(set) var moduliteTeamLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = .localized(for: HelpLocalizedTexts.helpViewEncounteredBugText2)
        
        return label
    }()
    
    // MARK: - Initiliazers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        backgroundColor = .whiteTurnip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func reportIssuesButtonTapped() {
        onReportIssuesButtonTapped?()
    }
    
    // MARK: - Setup Methods
    func setTopics(to topics: [HelpTopicModel]) {
        topicsStackView.populateTopics(with: topics)
    }
    
    private func addSubviews() {
        addSubview(contentView)
        
        contentView.addSubview(topicsStackView)
        contentView.addSubview(reportIssuesButton)
        contentView.addSubview(moduliteTeamLabel)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
            )
            make.width.equalToSuperview().offset(-48)
        }
        
        topicsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        reportIssuesButton.snp.makeConstraints { make in
            make.top.equalTo(topicsStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        moduliteTeamLabel.snp.makeConstraints { make in
            make.top.equalTo(reportIssuesButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
