//
//  SceneDelegateRouter.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

/// A `Router` implementation that controls the main window's root view controller in the SceneDelegate.
class SceneDelegateRouter: Router {
    /// The main window where view controllers are presented.
    let window: UIWindow
    
    /// Initializes a new router with the specified window.
    /// - Parameter window: The main UIWindow to be managed by the router.
    init(window: UIWindow) {
        self.window = window
    }
    
    /// Sets the specified view controller as the root of the window and makes the window key and visible.
    /// - Parameters:
    ///   - viewController: The view controller to present as root.
    ///   - animated: Ignored in this implementation since root changes are not animated.
    ///   - onDismiss: Optional closure that is not used in this context.
    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    /// No-op implementation of dismiss, as dismissing the root view controller is not applicable.
    /// - Parameter animated: Ignored as there is no dismissal action.
    func dismiss(animated: Bool) { }
}

