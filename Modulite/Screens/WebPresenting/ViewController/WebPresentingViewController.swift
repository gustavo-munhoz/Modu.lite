//
//  WebPresentingViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/11/24.
//

import UIKit

class WebPresentingViewController: UIViewController {
    
    // MARK: - Properties
    private let presentingView = WebPresentingView()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = presentingView
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Actions
    func setURL(_ url: URL) {
        presentingView.loadURL(url)
    }
}
