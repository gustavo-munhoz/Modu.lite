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
        view.textColor = .darkGray
        
        return view
    }()
    
    private(set) lazy var dailyAvarageYesterdayLabel: DailyAverageStackView = {
        let view = DailyAverageStackView(
            titleText: .localized(for: .usageDailyAvarageYesterday),
            timeText: "3h 40min",
            timeBorderColor: .red
        )
        return view
    }()
    
    private(set) lazy var dailyAvarageLastWeek: DailyAverageStackView = {
        let view = DailyAverageStackView(
            titleText: .localized(for: .usageDailyAvarageLastWeek),
            timeText: "1h 20min",
            timeBorderColor: .fiestaGreen
        )
        return view
    }()
    
    private(set) lazy var howSpentYourTime: UILabel = {
        let view = UILabel()
        view.text = .localized(for: .usageHowSpentYourTime)
        view.font = UIFont(textStyle: .title3, symbolicTraits: .traitBold.union(.traitItalic))
        view.textColor = .darkGray
        return view
    }()

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
        addSubview(dailyAvarageYesterdayLabel)
        addSubview(dailyAvarageLastWeek)
        addSubview(howSpentYourTime)
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
        dailyAvarageYesterdayLabel.snp.makeConstraints { make in
            make.top.equalTo(comparisonOverviewLabel.snp.bottom).offset(20)
            make.left.equalTo(55)
            make.height.equalTo(87)
            
        }
        dailyAvarageLastWeek.snp.makeConstraints { make in
            make.top.equalTo(comparisonOverviewLabel.snp.bottom).offset(20)
            make.left.equalTo(dailyAvarageYesterdayLabel.snp.right).offset(30)
            make.height.equalTo(87)
            
        }
        howSpentYourTime.snp.makeConstraints { make in
            make.top.equalTo(dailyAvarageLastWeek.snp.bottom).offset(40)
            make.left.equalTo(comparisonOverviewLabel)
        }
    }
}

class DailyAverageStackView: UIStackView {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemGray
        label.numberOfLines = -1
        label.font = UIFont(textStyle: .footnote, weight: .semibold)
        return label
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.borderWidth = 3
        label.layer.cornerRadius = 20
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    init(titleText: String, timeText: String, timeBorderColor: UIColor) {
        super.init(frame: .zero)
        
        titleLabel.text = titleText
        timeLabel.text = timeText
        timeLabel.layer.borderColor = timeBorderColor.cgColor
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(timeLabel)
        
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 6
        
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(125)
        }
        timeLabel.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(125)
        }
    }
}
