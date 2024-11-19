//
//  SubscriptionDetailsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import UIKit

// swiftlint:disable:next type_name
protocol SubscriptionDetailsViewControllerDelegate: AnyObject {
    func subscriptionDetailsViewControllerDidPressUpgrade(
        _ viewController: SubscriptionDetailsViewController
    )
}

class SubscriptionDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private let subscriptionView = SubscriptionDetailsView()
    
    weak var delegate: SubscriptionDetailsViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = subscriptionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionView.purchasedSkinsCountLabel.text = "\(PurchaseManager.shared.purchasedSkins.count)"
        setupNavigationBar()
        setupViewActions()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationItem.title = .localized(
            for: SettingsLocalizedTexts.settingsViewSubscriptionDetailsTitle
        )
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViewActions() {
        subscriptionView.onUpgradeToPlusTapped = didPressUpgrade
    }
    
    // MARK: - Actions
    
    func didPressUpgrade() {
        delegate?.subscriptionDetailsViewControllerDidPressUpgrade(self)
    }
}

extension SubscriptionDetailsViewController {
    static func instantiate(delegate: SubscriptionDetailsViewControllerDelegate) -> Self {
        let vc = Self()
        vc.delegate = delegate
        
        return vc
    }
}
