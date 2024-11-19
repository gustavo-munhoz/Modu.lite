//
//  SubscriptionDetailsView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import UIKit
import SnapKit

class SubscriptionDetailsView: UIView {
    
    // MARK: - Properties
    
    var onUpgradeToPlusTapped: (() -> Void)?
    
    private let planTitleLabel = SubscriptionDetailsSmallTitle(
        localizedKey: .subsctiptionDetailsViewPlanTitle
    )
    
    private(set) lazy var currentPlanStack: UIStackView = {
        let title = SubscriptionDetailsDefaultLabel(
            localizedKey: .subsctiptionDetailsViewCurrentPlan
        )
        
        let badge = ModuliteFreeSmallBadge()
        badge.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        
        let spacer = UIView()
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let view = UIStackView(arrangedSubviews: [title, spacer, badge])
        
        view.distribution = .fill
        view.axis = .horizontal
        
        return view
    }()
    
    private(set) lazy var upgradeToPlusButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.baseBackgroundColor = .clear
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        
        let title = SubscriptionDetailsDefaultLabel(
            localizedKey: .subsctiptionDetailsViewUpgradeToPlus
        )
        title.backgroundColor = .clear
        
        button.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(didTapUpgradeToPlus), for: .touchUpInside)
                
        button.configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                if button.isHighlighted {
                    button.backgroundColor = .lightGray.withAlphaComponent(0.15)
                } else {
                    button.backgroundColor = .clear
                }
            }
        }
        
        let separator = SeparatorView()
        
        button.addSubview(separator)
            
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        return button
    }()
    
    private let skinsTitleLabel = SubscriptionDetailsSmallTitle(
        localizedKey: .subsctiptionDetailsViewSkinsTitle
    )
    
    private let purchasedSkinsLabel = SubscriptionDetailsDefaultLabel(
        localizedKey: .subsctiptionDetailsViewPurchasedSkins
    )
    
    private(set) lazy var purchasedSkinsCountLabel: SubscriptionDetailsDefaultLabel = {
        let view = SubscriptionDetailsDefaultLabel()
        view.text = "0"
        
        return view
    }()
    
    private(set) lazy var purchasedSkinsStack: UIStackView = {
        let spacer = UIView()
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let view = UIStackView(arrangedSubviews: [purchasedSkinsLabel, spacer, purchasedSkinsCountLabel])
        
        view.distribution = .fill
        view.axis = .horizontal
        
        let separator = SeparatorView()
        
        view.addSubview(separator)
            
        separator.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        return view
    }()
    
    private(set) lazy var modulitePlusBadge: UIView = {
        let view = LargeButtonPlus()
        view.onUpgradeButtonPress = didTapUpgradeToPlus
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
    
    // MARK: - Actions
    @objc private func didTapUpgradeToPlus() {
        print("Upgrade to Plus Tapped")
        onUpgradeToPlusTapped?()
    }
    
    // MARK: - Setup Methods
    private func addSubviews() {
        addSubview(planTitleLabel)
        addSubview(currentPlanStack)
        addSubview(upgradeToPlusButton)
        
        addSubview(skinsTitleLabel)
        addSubview(purchasedSkinsStack)
        addSubview(modulitePlusBadge)
    }
    
    private func setupConstraints() {
        planTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        currentPlanStack.snp.makeConstraints { make in
            make.top.equalTo(planTitleLabel.snp.bottom).offset(16)
            make.left.right.equalTo(planTitleLabel)
        }
        
        upgradeToPlusButton.snp.makeConstraints { make in
            make.top.equalTo(currentPlanStack.snp.bottom).offset(8)
            make.height.equalTo(40)
            make.left.right.equalTo(currentPlanStack)
        }
        
        skinsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(upgradeToPlusButton.snp.bottom).offset(16)
            make.left.right.equalTo(upgradeToPlusButton)
        }
        
        purchasedSkinsStack.snp.makeConstraints { make in
            make.top.equalTo(skinsTitleLabel.snp.bottom).offset(16)
            make.left.right.equalTo(skinsTitleLabel)
        }
        
        modulitePlusBadge.snp.makeConstraints { make in
            make.left.right.equalTo(purchasedSkinsStack)
            make.top.equalTo(purchasedSkinsStack.snp.bottom).offset(24)
        }
    }
}

#Preview {
    SubscriptionDetailsView()
}
