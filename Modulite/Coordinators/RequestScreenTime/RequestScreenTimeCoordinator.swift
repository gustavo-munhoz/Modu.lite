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
    
    var type: ScreenTimeRequestType = .usage
    
    init(router: Router) {
        self.router = router
    }
    
    init(router: Router, requestType: ScreenTimeRequestType) {
        self.router = router
        self.type = requestType
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = RequestScreenTimeViewController.instantiate(
            delegate: self, type: self.type
        )
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}

extension RequestScreenTimeCoordinator: RequestScreenTimeViewControllerDelegate {
    func requestScreenTimeDidPressConnect(
        _ viewController: RequestScreenTimeViewController
    ) {
        UserPreference<ScreenTime>.shared.set(true, for: .hasSetPreferenceBefore)
        FamilyControlsManager.shared.requestAuthorization { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.router.dismiss(animated: true)
            }
        }
    }
    
    func requestScreenTimeDidPressDismiss(
        _ viewController: RequestScreenTimeViewController
    ) {
        UserPreference<ScreenTime>.shared.set(true, for: .hasSetPreferenceBefore)
        router.dismiss(animated: true)
    }
}
