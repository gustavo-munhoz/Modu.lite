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
    
    var onCompletion: (Result<Void, Error>) -> Void = { _ in }
    
    init(router: Router) {
        self.router = router
    }
    
    init(router: Router, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        self.router = router
        self.onCompletion = onCompletion
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
        onCompletion(.success(()))
        router.dismiss(animated: true)
    }
    
    func requestScreenTimeDidPressDismiss(
        _ viewController: RequestScreenTimeViewController
    ) {
        let error = NSError(
            domain: "dev.mnhz.modu.lite",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "User dismissed the screen time request."]
        )

        onCompletion(.failure(error))
        router.dismiss(animated: true)
    }
}
