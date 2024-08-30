//
//  UsageViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

class UsageViewController: UIViewController {
    
    private var usageView = UsageView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = usageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup methods
    private func setupNavigationBar() {
        navigationItem.title = .localized(for: .usageViewControllerNavigationTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
