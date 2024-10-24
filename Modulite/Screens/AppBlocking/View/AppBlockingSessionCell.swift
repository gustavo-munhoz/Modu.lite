//
//  AppBlockingSessionCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/10/24.
//

import UIKit
import SnapKit

protocol AppBlockingSessionCellDelegate: AnyObject {
    func appBlockingSessionCell(
        _ cell: AppBlockingSessionCell,
        didToggleTo newValue: Bool
    )
}

class AppBlockingSessionCell: UICollectionViewCell {
    static let reuseId = "AppBlockingSessionCell"
    
    weak var delegate: AppBlockingSessionCellDelegate?
    
    // MARK: - Subviews
    private(set) lazy var sessionSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .fiestaGreen
        view.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return view
    }()
    
    private(set) lazy var sessionName: UILabel = {
        let view = UILabel()
        view.font = UIFont(textStyle: .title3, weight: .semibold)
        view.adjustsFontSizeToFitWidth = true
        
        return view
    }()
    
    private(set) lazy var sessionInfo: UILabel = {
        let view = UILabel()
        view.font = UIFont(textStyle: .callout, weight: .semibold)
        
        return view
    }()
    
    private(set) lazy var blockedAppsCountLabel: PaddedLabel = {
        let view = PaddedLabel()
        view.font = UIFont(textStyle: .callout, weight: .semibold)
        
        return view
    }()
    
    // MARK: - Setup Methods
    func setup(
        delegate: AppBlockingSessionCellDelegate,
        session: AppBlockingSession
    ) {
        sessionSwitch.isOn = session.isActive
        sessionName.text = session.sessionName
        sessionInfo.text = "\(session.startsAt) - \(session.endsAt)  |  \(session.daysOfWeek.count) days a week"
        blockedAppsCountLabel.text = "\(session.totalSelectionCount) blocked apps"
        
        addSubviews()
        setupConstraints()
        
        backgroundColor = .potatoYellow.withAlphaComponent(0.75)
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    private func addSubviews() {
        addSubview(sessionSwitch)
        addSubview(sessionName)
        addSubview(sessionInfo)
        addSubview(blockedAppsCountLabel)
    }
    
    private func setupConstraints() {
        sessionSwitch.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().inset(24)
            make.width.equalTo(51)
            make.height.equalTo(31)
        }
        
        sessionName.snp.makeConstraints { make in
            make.centerY.equalTo(sessionSwitch)
            make.left.equalTo(sessionSwitch.snp.right).offset(12)
            make.right.equalToSuperview().inset(32)
        }
        
        sessionInfo.snp.makeConstraints { make in
            make.top.equalTo(sessionSwitch.snp.bottom).offset(12)
            make.left.equalTo(sessionSwitch)
            make.right.equalTo(sessionName)
        }
        
        blockedAppsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(sessionInfo.snp.bottom).offset(12)
            make.left.equalTo(sessionInfo)
            make.width.greaterThanOrEqualTo(130)
        }
    }
    
    // MARK: - Actions
    @objc private func switchValueChanged(_ sender: UISwitch) {
        delegate?.appBlockingSessionCell(self, didToggleTo: sender.isOn)
    }
}
