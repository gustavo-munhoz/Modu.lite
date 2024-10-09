//
//  SettingsCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit

/// A `Coordinator` that manages the presentation of the settings screen in the application.
class SettingsCoordinator: Coordinator {
    /// Child coordinators managed by this coordinator.
    var children: [Coordinator] = []
    
    /// The router used to present view controllers.
    let router: Router
    
    /// Initializes a new instance of `SettingsCoordinator` with a router.
    /// - Parameter router: The router that will handle presentation and dismissal of view controllers.
    init(router: Router) {
        self.router = router
    }
    
    /// Presents the settings view controller using the associated router.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the settings view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = SettingsViewController.instantiate(delegate: self)
        
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func settingsViewControllerDidPressSubscription(_ viewController: SettingsViewController) {
        let coordinator = SubscriptionDetailsCoordinator(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    func settingsViewControllerDidPressTutorials(_ viewController: SettingsViewController) {
        let coordinator = TutorialCenterCoordinator(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    func settingsViewControllerDidPressFAQ(_ viewController: SettingsViewController) {
        // TODO: Present FAQ view
    }
    
    func settingsViewControllerDidPressHelp(_ viewController: SettingsViewController) {
        // TODO: Present Help view
    }
}
