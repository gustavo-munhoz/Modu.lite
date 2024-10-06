//
//  TutorialEditWidgetCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit

class TutorialEditWidgetCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = TutorialEditWidgetViewController()
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}
