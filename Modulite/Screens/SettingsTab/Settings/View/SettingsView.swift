//
//  SettingsView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import UIKit
import SnapKit

class SettingsView: UIView {
    
    // MARK: - Properties
    
    private(set) lazy var profilePicture: UIImageView = {
        let view = UIImageView()
        view.image = .finderProfilePicture
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) lazy var usernameTextField: UITextField = {
        let view = UITextField()
        view.text = .localized(for: .guest)
        view.font = UIFont(textStyle: .title2, weight: .bold)
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private(set) var subscriptionFreeBadge = ModuliteFreeSmallBadge()
    
    private(set) lazy var preferencesTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.rowHeight = 50
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        
        view.register(
            PreferenceTableViewCell.self,
            forCellReuseIdentifier: PreferenceTableViewCell.reuseId
        )
        
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
    
    // MARK: - Setup Methods
    
    func setTableViewDelegate(to delegate: UITableViewDelegate) {
        preferencesTableView.delegate = delegate
    }
    
    func setTableViewDataSource(to dataSource: UITableViewDataSource) {
        preferencesTableView.dataSource = dataSource
    }
    
    private func addSubviews() {
        addSubview(profilePicture)
        addSubview(usernameTextField)
        addSubview(subscriptionFreeBadge)
        addSubview(preferencesTableView)
    }
    
    private func setupConstraints() {
        profilePicture.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.left.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(95)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(profilePicture).offset(12)
            make.left.equalTo(profilePicture.snp.right).offset(16)
        }
        
        subscriptionFreeBadge.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(5)
            make.left.equalTo(usernameTextField)
        }
        
        preferencesTableView.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.bottom).offset(32)
            make.left.right.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}
