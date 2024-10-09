//
//  TutorialCreateWidgetViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit

class TutorialCreateWidgetViewController: UIViewController, TutorialViewController {
    
    // MARK: - Properties
    var tutorialView = TutorialCreateWidgetView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = tutorialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
}
