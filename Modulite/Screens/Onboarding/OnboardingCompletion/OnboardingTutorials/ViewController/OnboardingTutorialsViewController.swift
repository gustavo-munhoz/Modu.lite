//
//  OnboardingTutorialsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit

enum OnboardingTutorialType {
    case wallpaper
    case widget
}

protocol OnboardingTutorialsControllerDelegate: AnyObject {
    func onboardingTutorialsViewController(
        _ viewController: OnboardingTutorialsViewController,
        didPressPresent tutorial: OnboardingTutorialType
    )
    
    func onboardingTutorialsViewControllerDidPressAllSet(
        _ viewController: OnboardingTutorialsViewController
    )
}

class OnboardingTutorialsViewController: UIViewController {
    
    // MARK: - Properties
    private let tutorialsView = OnboardingTutorialsView()
    
    weak var delegate: OnboardingTutorialsControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = tutorialsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewActions()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .whiteTurnip
    }
    
    private func setupViewActions() {
        tutorialsView.textBox1.onTutorialButtonPressed = { [weak self] in
            guard let self = self else { return }
            self.didPressWallpaperButton()
        }
        
        tutorialsView.textBox2.onTutorialButtonPressed = { [weak self] in
            guard let self = self else { return }
            self.didPressWidgetButton()
        }
        
        tutorialsView.onAllSetButtonPressed = didPressAllSetButton
    }

    // MARK: - Actions
    private func didPressWallpaperButton() {
        delegate?.onboardingTutorialsViewController(
            self,
            didPressPresent: .wallpaper
        )
    }
    
    private func didPressWidgetButton() {
        delegate?.onboardingTutorialsViewController(
            self,
            didPressPresent: .widget
        )
    }
    
    private func didPressAllSetButton() {
        delegate?.onboardingTutorialsViewControllerDidPressAllSet(self)
    }
}
