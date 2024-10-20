//
//  RequestScreenTimeCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 19/10/24.
//

import UIKit

class RequestScreenTimeCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
            
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = RequestScreenTimeViewController.instantiate(delegate: self)
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}

extension RequestScreenTimeCoordinator: RequestScreenTimeViewControllerDelegate {
    func requestScreenTimeDidPressConnect(
        _ viewController: RequestScreenTimeViewController
    ) {
        
    }
    
    func requestScreenTimeDidPressDismiss(
        _ viewController: RequestScreenTimeViewController
    ) {
        
    }
}
