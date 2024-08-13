//
//  RootTabCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

class RootTabCoordinator: Coordinator {
    var children: [Coordinator] = []
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let rootTabBarController = RootTabBarController()
        
        router.present(rootTabBarController, animated: animated, onDismiss: onDismiss)
        setupTabs(for: rootTabBarController)
    }
    
    private func setupTabs(for rootTabBarController: RootTabBarController) {
        let viewControllersAndCoordinators = createCoordinatorsAndViewControllers(withParent: rootTabBarController)
        rootTabBarController.viewControllers = viewControllersAndCoordinators.map { $0.0 }
        children = viewControllersAndCoordinators.map { $0.1 }        
    }

    private func createCoordinatorsAndViewControllers(withParent parent: UIViewController) -> [(UIViewController, Coordinator)] {
        let homeNav = UINavigationController(rootViewController: HomeViewController())
        homeNav.tabBarItem = UITabBarItem(
            title: .localized(for: .homeViewControllerTabBarItemTitle),
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        let homeRouter = HomeNavigationRouter(parentViewController: parent)
        let homeCoordinator = HomeCoordinator(router: homeRouter)
        
        // TODO: Add other view controllers.
        
        return [
            (homeNav, homeCoordinator)
        ]
    }
}

