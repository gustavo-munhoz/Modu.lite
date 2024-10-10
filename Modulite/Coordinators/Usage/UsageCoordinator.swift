//
//  UsageCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import Foundation

/// A `Coordinator` that manages the presentation of the usage screen in the application.
class UsageCoordinator: Coordinator {
    /// Child coordinators managed by this coordinator.
    var children: [Coordinator] = []
    
    /// The router used to present view controllers.
    let router: Router
    
    /// Initializes a new instance of `UsageCoordinator` with a router.
    /// - Parameter router: The router that will handle presentation and dismissal of view controllers.
    init(router: Router) {
        self.router = router
    }
    
    /// Presents the usage view controller using the associated router.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the usage view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = UsageViewController()
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}
