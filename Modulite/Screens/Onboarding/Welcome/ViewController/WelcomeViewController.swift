//
//  WelcomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

import UIKit

protocol WelcomeViewControllerDelegate: AnyObject {
    func welcomeViewControllerDidPressStart(
        _ viewController: WelcomeViewController
    )
}

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    private let welcomeView = WelcomeView()
    
    weak var delegate: WelcomeViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()
    }
    
    // MARK: - Setup Methods
    private func setupViewActions() {
        welcomeView.onStartButtonPressed = didPressStart
    }
    
    // MARK: - Actions
    private func didPressStart() {
        UserPreference<Onboarding>.shared.set(true, for: .hasCompletedOnboarding)
        
        delegate?.welcomeViewControllerDidPressStart(self)
    }
}
