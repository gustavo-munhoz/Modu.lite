//
//  HelpViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit

protocol HelpViewControllerDelegate: AnyObject {
    func helpViewControllerDidPressReportIssue(
        _ viewController: HelpViewController
    )
}

class HelpViewController: UIViewController {
    // MARK: - Properties
    private let helpView = HelpView()
    private let viewModel = HelpViewModel()
    
    weak var delegate: HelpViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = helpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = .localized(for: SettingsLocalizedTexts.settingsViewHelpTitle)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        helpView.setTopics(to: viewModel.helpTopics)
        helpView.onReportIssuesButtonTapped = didPressReportIssue
    }
    
    // MARK: - Actions
    func didPressReportIssue() {
        delegate?.helpViewControllerDidPressReportIssue(self)
    }
}

extension HelpViewController {
    static func instantiate(delegate: HelpViewControllerDelegate) -> Self {
        let vc = Self()
        vc.delegate = delegate
        
        return vc
    }
}
