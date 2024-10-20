//
//  RequestScreenTimeDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 19/10/24.
//

import UIKit

class RequestScreenTimeDelegate: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
            
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = RequestScreenTimeViewController()
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}
