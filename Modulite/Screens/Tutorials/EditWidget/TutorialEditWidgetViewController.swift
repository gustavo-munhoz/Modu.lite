//
//  TutorialEditWidgetViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialEditWidgetViewController: UIViewController, TutorialViewController {
    
    private let tutorialView = TutorialEditWidgetView()
    
    override func loadView() {
        view = tutorialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
}
