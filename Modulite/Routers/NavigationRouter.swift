//
//  NavigationRouter.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

class NavigationRouter: NSObject {
    private let navigationController: UINavigationController
    private let routerRootController: UIViewController?
    /// A dictionary that contains dismiss closures for children `UIViewControllers`.
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.routerRootController = navigationController.viewControllers.first
        super.init()
        self.navigationController.delegate = self
    }
}

extension NavigationRouter: Router {
    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismiss
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController.popToRootViewController(animated: animated)
            return
        }
        
        performOnDismissed(for: routerRootController)
        navigationController.popToViewController(routerRootController, animated: animated)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
      guard let onDismiss = onDismissForViewController[viewController] else { return }
      
      onDismiss()
      onDismissForViewController[viewController] = nil
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
      guard let dismissedVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(dismissedVC) else { return }
      
      performOnDismissed(for: dismissedVC)
    }
}
