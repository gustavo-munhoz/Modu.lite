//
//  LoadingViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .whiteTurnip
                
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
