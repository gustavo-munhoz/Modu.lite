//
//  ModalNavigationRouter.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit

class ModalNavigationRouter: NSObject {
    unowned let parentViewController: UIViewController
    private let navigationController = UINavigationController()
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
        self.navigationController.delegate = self
        self.navigationController.presentationController?.delegate = self
        self.navigationController.sheetPresentationController?.prefersGrabberVisible = true
    }
}

extension ModalNavigationRouter: Router {
    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismiss
        
        if navigationController.viewControllers.isEmpty {
            presentModally(viewController, animated: animated)
            
        } else {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    private func presentModally(_ viewController: UIViewController, animated: Bool) {
        addRightSaveButton(to: viewController)
        navigationController.setViewControllers([viewController], animated: false)
        parentViewController.present(navigationController, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        performOnDismiss(for: navigationController.viewControllers.first!)
        parentViewController.dismiss(animated: animated)
    }
    
    private func addRightSaveButton(to viewController: UIViewController) {
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: .localized(for: .save),
            style: .plain,
            target: self,
            action: #selector(savePressed)
        )
        viewController.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.fiestaGreen,
                NSAttributedString.Key.font: UIFont(
                    textStyle: .body,
                    weight: .semibold,
                    italic: true
                )
            ],
            for: .normal
        )
    }
    
    @objc private func savePressed() {
        performOnDismiss(for: navigationController.viewControllers.first!)
        parentViewController.dismiss(animated: true)
    }
    
    private func performOnDismiss(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

extension ModalNavigationRouter: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let dismissedVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(dismissedVC) else { return }
        
        performOnDismiss(for: dismissedVC)
    }
}

extension ModalNavigationRouter: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        if let topViewController = navigationController.topViewController {
            performOnDismiss(for: topViewController)
        }
    }
}
