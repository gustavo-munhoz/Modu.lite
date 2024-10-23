//
//  AppBlockingViewController.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import UIKit

class AppBlockingViewController: UIViewController {
    
    private var appBlockingView = AppBlockingView()
    
    override func loadView() {
        view = appBlockingView
        view.backgroundColor = .whiteTurnip
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
