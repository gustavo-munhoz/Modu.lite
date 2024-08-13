//
//  HomeNavigationRouter.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

class HomeNavigationRouter: NSObject {
    unowned let parentViewController: UIViewController
    private let navigationController = UINavigationController()
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
        self.navigationController.delegate = self
    }
}

extension HomeNavigationRouter: Router {
    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismiss
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        performOnDismissed(for: navigationController.viewControllers.first!)
        parentViewController.dismiss(animated: animated)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
      guard let onDismiss = onDismissForViewController[viewController] else { return }
      
      onDismiss()
      onDismissForViewController[viewController] = nil
    }
}

extension HomeNavigationRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
      guard let dismissedVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(dismissedVC) else { return }
      
      performOnDismissed(for: dismissedVC)
    }
}
