//
//  UsageView.swift
//  Modulite
//
//  Created by André Wozniack on 29/08/24.
//

import UIKit
import SnapKit

class UsageView: UIView {
    
    // MARK: - Properties
    
    private(set) lazy var youHaveSpentLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: .usageViewYouHaveSpent)
        label.font = UIFont(textStyle: .headline, weight: .semibold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private(set) lazy var timeSpentLabel: UILabel = {
        // TODO: Make text recive data from model
        let label = UILabel()
        label.text = "1h 20min"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = UIColor.black
        label.layer.borderWidth = 4
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.cornerRadius = 20
        return label
    }()
        
    private(set) lazy var onPhoneTodayLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: .usageViewOnPhone)
        label.font = UIFont(textStyle: .headline, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private(set) lazy var comparisonOverviewLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: .usageViewComparisonOverview)
        view.font = UIFont(textStyle: .body, symbolicTraits: .traitBold.union(.traitItalic))
        view.textColor = .systemGray
        
        return view
    }()
    
    // TODO: 
    
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
    
    // MARK: - Setup methods
    
    private func addSubviews() {
        addSubview(youHaveSpentLabel)
        addSubview(timeSpentLabel)
        addSubview(onPhoneTodayLabel)
        addSubview(comparisonOverviewLabel)
    }
    
    private func setupConstraints() {
        youHaveSpentLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            
        }
        timeSpentLabel.snp.makeConstraints { make in
            make.top.equalTo(youHaveSpentLabel.snp.bottom).offset(10)
            make.height.equalTo(90)
            make.width.equalTo(230)
            make.centerX.equalTo(youHaveSpentLabel)
        }
        
        onPhoneTodayLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSpentLabel.snp.bottom).offset(10)
            make.centerX.equalTo(timeSpentLabel)
        }
        comparisonOverviewLabel.snp.makeConstraints { make in
            make.top.equalTo(onPhoneTodayLabel.snp.bottom).offset(25)
            make.left.equalTo(safeAreaLayoutGuide).offset(23)
            
        }
    }
}
