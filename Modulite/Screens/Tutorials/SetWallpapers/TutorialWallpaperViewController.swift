//
//  TutorialWallpaperViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/10/24.
//

import UIKit

class TutorialWallpaperViewController: UIViewController, TutorialViewController {
    
    private var tutorialView = TutorialWallpaperView()
    
    override func loadView() {
        view = tutorialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = .whiteTurnip
    }
}
