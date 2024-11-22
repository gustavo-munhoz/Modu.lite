//
//  MajorChangesViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import UIKit

protocol MajorChangesViewControllerDelegate: AnyObject {
    func majorChangesViewControllerDidTapGotIt(
        _ viewController: MajorChangesViewController
    )
}

class MajorChangesViewController: UIViewController {
    
    // MARK: - Properties
    private let majorChangesView = MajorChangesView()
    
    weak var delegate: MajorChangesViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = majorChangesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        majorChangesView.onGotItButtonPress = didPressGotIt
    }
    
    // MARK: - Actions
    private func didPressGotIt() {
        delegate?.majorChangesViewControllerDidTapGotIt(self)
    }
}
