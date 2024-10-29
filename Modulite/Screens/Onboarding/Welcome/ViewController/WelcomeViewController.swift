//
//  WelcomeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    private let welcomeView = WelcomeView()
    
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
        
    }
}
