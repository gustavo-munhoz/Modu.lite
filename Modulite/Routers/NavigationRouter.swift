//
//  NavigationRouter.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

/// `NavigationRouter` manages navigation within a `UINavigationController`, handling the presentation
/// and dismissal of view controllers with support for cleanup via dismissal closures.
class NavigationRouter: NSObject {
    /// The primary navigation controller used by the router.
    private let navigationController: UINavigationController
    
    /// The root view controller of the navigation controller at the time of initialization.
    /// This is used as a reference point for certain dismiss operations.
    private let routerRootController: UIViewController?
    
    /// A dictionary that stores dismiss closures for each child view controller managed by this router.
    /// These closures are called when a view controller is dismissed, allowing for any necessary cleanup.
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    /// Initializes a new `NavigationRouter` with a specified navigation controller.
    /// - Parameter navigationController: The navigation controller this router will manage.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.routerRootController = navigationController.viewControllers.first
        super.init()
        self.navigationController.delegate = self
    }
}

extension NavigationRouter: Router {
    /// Presents a view controller within the managed navigation controller stack.
    /// - Parameters:
    ///   - viewController: The view controller to present.
    ///   - animated: A Boolean value indicating whether the presentation should be animated.
    ///   - onDismiss: An optional closure that is stored and called upon the dismissal of the view controller.
    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismiss
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    /// Dismisses the current view controller, or pops to a specific view controller in the navigation stack.
    /// If the `routerRootController` is set, pops to that controller; otherwise, pops to the root.
    /// - Parameter animated: A Boolean value indicating whether the dismissal should be animated.
    func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController.popToRootViewController(animated: animated)
            return
        }
        
        performOnDismissed(for: routerRootController)
        navigationController.popToViewController(routerRootController, animated: animated)
    }
    
    /// Executes the dismiss closure for a given view controller and removes it from the management dictionary.
    /// - Parameter viewController: The view controller for which to perform the dismiss closure.
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    /// Monitors navigation transitions and performs any necessary cleanup for view controllers that are removed from the stack.
    /// - Parameters:
    ///   - navigationController: The navigation controller performing the transition.
    ///   - viewController: The view controller that was shown in the transition.
    ///   - animated: A Boolean value indicating whether the transition was animated.
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let dismissedVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(dismissedVC) else { return }
        
        performOnDismissed(for: dismissedVC)
    }
}
