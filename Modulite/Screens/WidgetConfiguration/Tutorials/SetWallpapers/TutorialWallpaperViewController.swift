//
//  TutorialWallpaperViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/10/24.
//

import UIKit

class TutorialWallpaperViewController: UIViewController {
    
    private var tutorialView = TutorialWallpaperView()
    
    override func loadView() {
        view = tutorialView
    }
}
