//
//  RequestScreenTimeViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 18/10/24.
//

import UIKit

protocol RequestScreenTimeViewControllerDelegate: AnyObject {
    func requestScreenTimeDidPressConnect(_ viewController: RequestScreenTimeViewController)
    func requestScreenTimeDidPressDismiss(_ viewController: RequestScreenTimeViewController)
}

extension RequestScreenTimeViewController {
    static func instantiate(
        delegate: RequestScreenTimeViewControllerDelegate,
        type: ScreenTimeRequestType
    ) -> Self {
        let vc = Self()
        vc.delegate = delegate
        vc.type = type
        
        return vc
    }
}

class RequestScreenTimeViewController: UIViewController {
    
    // MARK: - Properties
    private let requestView = RequestScreenTimeView()
    
    weak var delegate: RequestScreenTimeViewControllerDelegate?
    
    private var type: ScreenTimeRequestType = .usage
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = requestView
        requestView.setRequestType(to: type)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()
    }
    
    // MARK: - Setup Methods
    
    private func setupViewActions() {
        requestView.onConnectButtonPress = handleConnectPress
        requestView.onDismissButtonPress = handleDismissPress
    }
    
    private func handleConnectPress() {
        delegate?.requestScreenTimeDidPressConnect(self)
    }
    
    private func handleDismissPress() {
        delegate?.requestScreenTimeDidPressDismiss(self)
    }
}
