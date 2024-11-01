//
//  OnboardingTutorialsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit

class OnboardingTutorialsViewController: UIViewController {
    
    // MARK: - Properties
    private let setWallpaperView = OnboardingTutorialsView()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = setWallpaperView
    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()        
//    }
    
    // MARK: - Setup Methods
}
