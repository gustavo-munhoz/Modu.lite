//
//  RootTabCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

/// A coordinator responsible for managing the root tab bar controller of the application.
/// This coordinator initializes and configures the navigation controllers for each tab,
/// embedding appropriate view controllers and setting up their corresponding coordinators.
class RootTabCoordinator: Coordinator {
    /// A list of child coordinators for each tab.
    var children: [Coordinator] = []
    
    /// The router responsible for presenting the root tab bar controller.
    let router: Router
    
    /// The root tab bar controller managed by this coordinator.
    let rootTabBarController = RootTabBarController()
    
    /// Initializes the coordinator with a router.
    /// - Parameter router: The router used for presenting the root tab bar controller.
    init(router: Router) {
        self.router = router
    }
    
    /// Presents the root tab bar controller and sets up the tabs.
    /// - Parameters:
    ///   - animated: Indicates whether the presentation should be animated.
    ///   - onDismiss: An optional closure that is called when the tab bar controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        router.present(rootTabBarController, animated: animated, onDismiss: onDismiss)
        setupTabs(for: rootTabBarController)
    }
    
    /// Configures the view controllers and their corresponding coordinators for each tab.
    /// - Parameter rootTabBarController: The root tab bar controller to configure.
    private func setupTabs(for rootTabBarController: RootTabBarController) {
        rootTabBarController.viewControllers = [
            configureHome(),
            configureUsage(),
            configureBlockApps(),
            configureSettings()
        ]
    }

    /// Creates and configures the Home tab with a navigation controller.
    /// - Returns: A configured navigation controller for the Home tab.
    private func configureHome() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        navigationController.tabBarItem = createTabBarItem(
            titleKey: .homeViewControllerTabBarItemTitle,
            imageName: "house",
            selectedImageName: "house.fill"
        )
        let homeRouter = NavigationRouter(navigationController: navigationController)
        let homeCoordinator = HomeCoordinator(router: homeRouter)
        children.append(homeCoordinator)
        return navigationController
    }
    
    /// Creates and configures the Usage tab with a navigation controller.
    /// This tab focuses on presenting statistical data and usage patterns to the user.
    /// - Returns: A configured navigation controller for the Usage tab.
    private func configureUsage() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: UsageViewController())
        navigationController.tabBarItem = createTabBarItem(
            titleKey: .usageViewControllerTabBarItemTitle,
            imageName: "chart.bar",
            selectedImageName: "chart.bar.fill"
        )
        let usageRouter = NavigationRouter(navigationController: navigationController)
        let usageCoordinator = UsageCoordinator(router: usageRouter)
        children.append(usageCoordinator)
        return navigationController
    }

    /// Creates and configures the Block Apps tab with a navigation controller.
    /// This tab allows users to manage application restrictions and settings.
    /// - Returns: A configured navigation controller for the Block Apps tab.
    private func configureBlockApps() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: BlockAppsViewController())
        navigationController.tabBarItem = createTabBarItem(
            titleKey: .blockAppsViewControllerTabBarItemTitle,
            imageName: "lock",
            selectedImageName: "lock.fill"
        )
        let blockAppsRouter = NavigationRouter(navigationController: navigationController)
        let blockAppsCoordinator = BlockAppsCoordinator(router: blockAppsRouter)
        children.append(blockAppsCoordinator)
        return navigationController
    }

    /// Creates and configures the Settings tab with a navigation controller.
    /// This tab provides users with options to customize application settings and preferences.
    /// - Returns: A configured navigation controller for the Settings tab.
    private func configureSettings() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: SettingsViewController())
        navigationController.tabBarItem = createTabBarItem(
            titleKey: .settingsViewControllerTabBarItemTitle,
            imageName: "gearshape",
            selectedImageName: "gearshape.fill"
        )
        let settingsRouter = NavigationRouter(navigationController: navigationController)
        let settingsCoordinator = SettingsCoordinator(router: settingsRouter)
        children.append(settingsCoordinator)
        return navigationController
    }

    /// Helper method to create a UITabBarItem with localized titles and specified icons.
    /// This method simplifies the creation of tab bar items by centralizing the configuration.
    /// - Parameters:
    ///   - titleKey: The localization key for the tab's title.
    ///   - imageName: The system image name for the tab icon.
    ///   - selectedImageName: The system image name for the selected tab icon.
    /// - Returns: A configured UITabBarItem.
    private func createTabBarItem(
        titleKey: String.LocalizedKey,
        imageName: String,
        selectedImageName: String,
        shouldFlipImageHorizontally: Bool = false
    ) -> UITabBarItem {
        return UITabBarItem(
            title: .localized(for: titleKey),
            image: UIImage(systemName: imageName),
            selectedImage: UIImage(systemName: selectedImageName)
        )
    }

}

