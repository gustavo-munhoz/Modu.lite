//
//  OnboardingCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

import UIKit

class OnboardingCoordinator: Coordinator {
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
        let vc = WelcomeViewController()
        vc.delegate = self
        
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}

extension OnboardingCoordinator: WelcomeViewControllerDelegate {
    func welcomeViewControllerDidPressStart(
        _ viewController: WelcomeViewController
    ) {
        let widgetCoordinator = WidgetBuilderCoordinator(router: router)
        widgetCoordinator.setHidesBackButton(true)
        widgetCoordinator.setIsOnboarding(true)
        
        presentChild(widgetCoordinator, animated: true)
    }
}
