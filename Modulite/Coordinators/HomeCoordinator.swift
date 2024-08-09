//
//  HomeCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

/// A `Coordinator` that manages the presentation of the home screen in the application.
class HomeCoordinator: Coordinator {
    /// Child coordinators managed by this coordinator.
    var children: [Coordinator] = []
    
    /// The router used to present view controllers.
    let router: Router
    
    /// Initializes a new instance of `HomeCoordinator` with a router.
    /// - Parameter router: The router that will handle presentation and dismissal of view controllers.
    init(router: Router) {
        self.router = router
    }
    
    /// Presents the home view controller using the associated router.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the home view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = HomeViewController()
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}
