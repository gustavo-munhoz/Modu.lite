//
//  OnboardingDeclutterHomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit

protocol OnboardingDeclutterControllerDelegate: AnyObject {
    func onboardingDeclutterHomeviewControllerDidFinish()
}

class OnboardingDeclutterHomeViewController: UIViewController {
    
    // MARK: - Properties
    private let declutterView = OnboardingDeclutterHomeView()
    
    weak var delegate: OnboardingDeclutterControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = declutterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()
    }
    
    // MARK: - Setup Methods
    private func setupViewActions() {
        declutterView.onGotItButtonPressed = didPressGotItButton
    }
    
    private func didPressGotItButton() {
        delegate?.onboardingDeclutterHomeviewControllerDidFinish()
    }
}
