//
//  SettingsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewControllerDidPressSubscription(
        _ viewController: SettingsViewController
    )
    
    func settingsViewControllerDidPressTutorials(
        _ viewController: SettingsViewController
    )
    
    func settingsViewControllerDidPressFAQ(
        _ viewController: SettingsViewController
    )
    
    func settingsViewControllerDidPressHelp(
        _ viewController: SettingsViewController
    )
}

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    private let settingsView = SettingsView()
    private let viewModel = SettingsViewModel()
    
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationItem.title = .localized(for: .settingsViewControllerTabBarItemTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .whiteTurnip
    }
    
    private func setupTableView() {
        settingsView.setTableViewDelegate(to: self)
        settingsView.setTableViewDataSource(to: self)
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellData = viewModel.getSettingData(at: indexPath.row) else {
            return
        }
        
        switch cellData.setting {
        case .subscription:
            delegate?.settingsViewControllerDidPressSubscription(self)
        case .tutorials:
            delegate?.settingsViewControllerDidPressTutorials(self)
        case .faq:
            delegate?.settingsViewControllerDidPressFAQ(self)
        case .help:
            delegate?.settingsViewControllerDidPressHelp(self)
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getSettingsCount()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PreferenceTableViewCell.reuseId,
            for: indexPath
        ) as? PreferenceTableViewCell else {
            fatalError("Unable to dequeue table view cell.")
        }
        
        guard let cellData = viewModel.getSettingData(at: indexPath.row) else {
            fatalError("Unable to get setting data for row \(indexPath.row).")
        }
        
        cell.setup(
            sfSymbolName: cellData.symbolName,
            iconColor: cellData.symbolColor,
            title: .localized(for: cellData.titleKey),
            hasBottomSeparator: indexPath.row == viewModel.getSettingsCount() - 1
        )
        
        return cell
    }
}

extension SettingsViewController {
    static func instantiate(delegate: SettingsViewControllerDelegate) -> SettingsViewController {
        let vc = SettingsViewController()
        vc.delegate = delegate
        
        return vc
    }
}
