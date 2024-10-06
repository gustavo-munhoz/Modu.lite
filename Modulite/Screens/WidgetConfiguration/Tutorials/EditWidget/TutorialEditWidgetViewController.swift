//
//  TutorialEditWidgetViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit

class TutorialEditWidgetViewController: UIViewController {
    
    private var tutorialView = TutorialEditWidgetView()
    
    override func loadView() {
        view = tutorialView
    }
}
