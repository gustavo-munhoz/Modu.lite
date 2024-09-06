//
//  SelectAppsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit

class SelectAppsViewController: UIViewController {
    
    // MARK: - Properties
    private var selectAppsView = SelectAppsView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = selectAppsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
