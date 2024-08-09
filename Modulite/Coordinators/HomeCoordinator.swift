//
//  HomeCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

class HomeCoordinator: Coordinator {
    var children: [Coordinator] = []
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = HomeViewController()
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}
