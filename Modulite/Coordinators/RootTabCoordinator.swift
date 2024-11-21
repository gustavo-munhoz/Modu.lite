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
    lazy var rootTabBarController = RootTabBarController.instantiate(delegate: self)
    
    private var loadingViewController: LoadingViewController?
    
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
        let loadingVC = LoadingViewController()
        self.loadingViewController = loadingVC
        
        guard let router = router as? SceneDelegateRouter else { return }
                
        router.window.rootViewController = loadingVC
        router.window.makeKeyAndVisible()
        
        loadData()
    }
    
    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            await SubscriptionManager.shared.initialize()
            await PurchaseManager.shared.initialize()
            
            self.showRootTabBarController()
        }
    }
    
    private func showRootTabBarController() {
        setupTabs(for: rootTabBarController)
        
        guard let router = router as? SceneDelegateRouter else { return }
        
        UIView.transition(
            with: router.window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let self else { return }
                router.window.rootViewController = self.rootTabBarController
            })
    }
    
    private func getKeyWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
        
        let windowScene = connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        
        return windowScene?.windows.first { $0.isKeyWindow }
    }
    
    /// Configures the view controllers and their corresponding coordinators for each tab.
    /// - Parameter rootTabBarController: The root tab bar controller to configure.
    private func setupTabs(for rootTabBarController: RootTabBarController) {
        rootTabBarController.viewControllers = [
            configureWidgets(),
            configureUsage(),
            configureBlockApps(),
            configureSettings()
        ]
    }

    /// Creates and configures the Widgets tab with a navigation controller.
    /// This tab focuses on all widgets settings
    /// - Returns: A configured navigation controller for the Widgets tab.
    private func configureWidgets() -> UINavigationController {
        let viewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let tabBarItem = createTabBarItem(
            titleKey: .homeViewControllerTabBarItemTitle,
            imageName: "square.grid.3x2.fill",
            selectedImageName: "square.grid.3x2.fill"
        )
        
        tabBarItem.tag = 0
        navigationController.tabBarItem = tabBarItem
        
        let widgetsRouter = NavigationRouter(navigationController: navigationController)
        let widgetsCoordinator = HomeCoordinator(router: widgetsRouter)
        viewController.delegate = widgetsCoordinator
        
        children.append(widgetsCoordinator)
        return navigationController
    }
    
    /// Creates and configures the Usage tab with a navigation controller.
    /// This tab focuses on presenting statistical data and usage patterns to the user.
    /// - Returns: A configured navigation controller for the Usage tab.
    private func configureUsage() -> UINavigationController {
//        #if DEBUG
        let vc = UsageViewController()
//        #else
//        let vc = ComingSoonViewController()
//        vc.fillComingSoonView(for: .screenTime)
//        #endif
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        let tabBarItem = createTabBarItem(
            titleKey: .usageViewControllerTabBarItemTitle,
            imageName: "chart.bar.xaxis",
            selectedImageName: "chart.bar.xaxis"
        )
        
        tabBarItem.tag = 1
        navigationController.tabBarItem = tabBarItem
        
        let usageRouter = NavigationRouter(navigationController: navigationController)
        let usageCoordinator = UsageCoordinator(router: usageRouter)
        
        children.append(usageCoordinator)
        return navigationController
    }

    /// Creates and configures the Block Apps tab with a navigation controller.
    /// This tab allows users to manage application restrictions and settings.
    /// - Returns: A configured navigation controller for the Block Apps tab.
    private func configureBlockApps() -> UINavigationController {
        #if DEBUG
        let vc = AppBlockingViewController()
        #else
        let vc = ComingSoonViewController()
        vc.fillComingSoonView(for: .appBlocking)
        #endif
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        let tabBarItem = createTabBarItem(
            titleKey: .blockAppsViewControllerTabBarItemTitle,
            imageName: "lock.fill",
            selectedImageName: "lock.fill"
        )
        
        tabBarItem.tag = 2
        navigationController.tabBarItem = tabBarItem
        
        let blockAppsRouter = NavigationRouter(navigationController: navigationController)
        let blockAppsCoordinator = BlockAppsCoordinator(router: blockAppsRouter)
        children.append(blockAppsCoordinator)
        return navigationController
    }

    /// Creates and configures the Settings tab with a navigation controller.
    /// This tab provides users with options to customize application settings and preferences.
    /// - Returns: A configured navigation controller for the Settings tab.
    private func configureSettings() -> UINavigationController {
        let settingsController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsController)
        
        let tabBarItem = createTabBarItem(
            titleKey: .settingsViewControllerTabBarItemTitle,
            imageName: "gearshape.fill",
            selectedImageName: "gearshape.fill"
        )
        
        tabBarItem.tag = 3
        navigationController.tabBarItem = tabBarItem
        
        let settingsRouter = NavigationRouter(navigationController: navigationController)
        let settingsCoordinator = SettingsCoordinator(router: settingsRouter)
        
        settingsController.delegate = settingsCoordinator
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
        selectedImageName: String
    ) -> UITabBarItem {
        let image = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        let tabBarItem = UITabBarItem(
            title: .localized(for: titleKey),
            image: image,
            selectedImage: selectedImage
        )
        
        return tabBarItem
    }
}

extension RootTabCoordinator: RootTabBarControllerDelegate {
    func rootTabBarControllerDidRequestScreenTime(
        _ viewController: RootTabBarController,
        in type: ScreenTimeRequestType
    ) {
        let router = ModalNavigationRouter(
            parentViewController: viewController,
            presentationStyle: .fullScreen
        )
        
        router.setHasSaveButton(false)
        
        let coordinator = RequestScreenTimeCoordinator(
            router: router,
            requestType: type
        )
        
        presentChild(coordinator, animated: true)
    }
    
    func rootTabBarController(
        _ viewController: RootTabBarController,
        shouldPresentOnboarding: Bool
    ) {
        guard shouldPresentOnboarding else { return }
        
        let router = ModalNavigationRouter(
            parentViewController: viewController,
            presentationStyle: .fullScreen
        )
        
        router.setHasSaveButton(false)
        
        let coordinator = OnboardingCoordinator(router: router)
        
        presentChild(coordinator, animated: true)
    }
}
