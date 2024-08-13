//
//  BlockAppsCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit

/// A `Coordinator` that manages the presentation of the block apps screen in the application.
class BlockAppsCoordinator: Coordinator {
    /// Child coordinators managed by this coordinator.
    var children: [Coordinator] = []
    
    /// The router used to present view controllers.
    let router: Router
    
    /// Initializes a new instance of `BlockAppsCoordinator` with a router.
    /// - Parameter router: The router that will handle presentation and dismissal of view controllers.
    init(router: Router) {
        self.router = router
    }
    
    /// Presents the block apps view controller using the associated router.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the block apps view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = BlockAppsViewController()
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}
