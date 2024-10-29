//
//  RedirectingViewController.swift
//  Modulite
//
//  Created by André Wozniack on 29/10/24.
//

import UIKit

class RedirectingViewController: UIViewController {
    
    private var redirectingView = RedirectingView()
    
    override func loadView() {
        view = redirectingView
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
}
