//
//  TutorialCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialCoordinator<T: UIViewController & TutorialViewController>: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = T()
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}
