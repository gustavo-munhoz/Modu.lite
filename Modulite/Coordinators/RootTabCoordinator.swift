//
//  RootTabCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

class RootTabCoordinator {
    var children: [Coordinator] = []
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
        
   
    private func setupTabs(for rootTabBarController: RootTabBarController) {
        let viewControllersAndCoordinators = createCoordinatorsAndViewControllers(withParent: rootTabBarController)
        rootTabBarController.viewControllers = viewControllersAndCoordinators.map { $0.0 }
        children = viewControllersAndCoordinators.map { $0.1 }
    }

    private func createCoordinatorsAndViewControllers(withParent parent: UIViewController) -> [(UIViewController, Coordinator)] {
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        homeNavigationController.tabBarItem = UITabBarItem(
            title: .localized(for: .homeViewControllerTabBarItemTitle),
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        let homeRouter = NavigationRouter(navigationController: homeNavigationController)
        let homeCoordinator = HomeCoordinator(router: homeRouter)
        
        
        let usageNavigationController = UINavigationController(rootViewController: UsageViewController())
        usageNavigationController.tabBarItem = UITabBarItem(
            title: .localized(for: .usageViewControllerTabBarItemTitle),
            image: UIImage(systemName: "chart.bar")?.withHorizontallyFlippedOrientation(),
            selectedImage: UIImage(systemName: "chart.bar.fill")?.withHorizontallyFlippedOrientation()
        )
        let usageRouter = NavigationRouter(navigationController: usageNavigationController)
        let usageCoordinator = UsageCoordinator(router: usageRouter)
        
        let blockAppsNavigationController = UINavigationController(rootViewController: BlockAppsViewController())
        blockAppsNavigationController.tabBarItem = UITabBarItem(
            title: .localized(for: .blockAppsViewControllerTabBarItemTitle),
            image: UIImage(systemName: "lock"),
            selectedImage: UIImage(systemName: "lock.fill")
        )
        let blockAppsRouter = NavigationRouter(navigationController: blockAppsNavigationController)
        let blockAppsCoordinator = BlockAppsCoordinator(router: blockAppsRouter)
        
        let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
        settingsNavigationController.tabBarItem = UITabBarItem(
            title: .localized(for: .settingsViewControllerTabBarItemTitle),
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        let settingsRouter = NavigationRouter(navigationController: settingsNavigationController)
        let settingsCoordinator = SettingsCoordinator(router: settingsRouter)
        
        return [
            (homeNavigationController, homeCoordinator),
            (usageNavigationController, usageCoordinator),
            (blockAppsNavigationController, blockAppsCoordinator),
            (settingsNavigationController, settingsCoordinator)
        ]
    }
}

extension RootTabCoordinator: Coordinator {
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let rootTabBarController = RootTabBarController()
        
        router.present(rootTabBarController, animated: animated, onDismiss: onDismiss)
        setupTabs(for: rootTabBarController)
    }
}
