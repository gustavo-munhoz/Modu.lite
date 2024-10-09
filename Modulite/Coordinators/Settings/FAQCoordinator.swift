//
//  FAQCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import Foundation

class FAQCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = FAQViewController.instantiate(delegate: self)
        vc.hidesBottomBarWhenPushed = true
        
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}

extension FAQCoordinator: FAQViewControllerDelegate {
    
}
