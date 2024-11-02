//
//  TutorialAddWidgetViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialAddWidgetViewController: UIViewController, TutorialViewController {
    
    private let tutorialView = TutorialAddWidgetView()
    
    override func loadView() {
        view = tutorialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = .whiteTurnip
    }
}
