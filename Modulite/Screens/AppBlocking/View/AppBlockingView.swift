//
//  AppBlockingView.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import UIKit
import SnapKit

class AppBlockingView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "App Blocking"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private(set) lazy var blockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Blocking Session", for: .normal)
        button.addTarget(self, action: #selector(addBlockingSessionTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.transform = CGAffineTransform(scaleX: 2.0, y: 2.0) // Aumenta o switch
        toggle.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        return toggle
    }()
    
    // MARK: - Callbacks
    
    var onAddSession: (() -> Void)?
    var onSwitchToggle: ((Bool) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews & Constraints
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(blockButton)
        addSubview(toggleSwitch)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        blockButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(blockButton.snp.bottom).offset(40)
        }
    }
    
    // MARK: - Actions
    
    @objc private func addBlockingSessionTapped() {
        onAddSession?()
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        onSwitchToggle?(sender.isOn)
    }
}
