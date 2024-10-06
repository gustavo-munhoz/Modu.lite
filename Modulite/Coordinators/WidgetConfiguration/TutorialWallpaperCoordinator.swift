//
//  TutorialWallpaperCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/10/24.
//

import Foundation

class TutorialWallpaperCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = TutorialWallpaperViewController()
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}
