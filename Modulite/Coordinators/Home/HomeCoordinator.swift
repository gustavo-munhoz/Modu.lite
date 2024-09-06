//
//  HomeCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

protocol HomeNavigationFlowDelegate: AnyObject {
    func navigateToWidgetSetup(forWidgetId id: UUID?)
    func navigateToWidgetEditor(withBuilder builder: WidgetConfigurationBuilder)
    func widgetSetupViewControllerDidPressSearchApps(_ viewController: WidgetSetupViewController)
}

/// A `Coordinator` that manages the presentation of the home screen in the application.
class HomeCoordinator: Coordinator {
    /// Child coordinators managed by this coordinator.
    var children: [Coordinator] = []
    
    /// The router used to present view controllers.
    let router: Router
    
    /// Initializes a new instance of `HomeCoordinator` with a router.
    /// - Parameter router: The router that will handle presentation and dismissal of view controllers.
    init(router: Router) {
        self.router = router
    }
    
    /// Presents the home view controller using the associated router.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the home view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = HomeViewController.instantiate(delegate: self)
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}

extension HomeCoordinator: HomeNavigationFlowDelegate {
    func navigateToWidgetSetup(forWidgetId id: UUID? = nil) {
        // FIXME: Identify widget and set/create data for it
        let viewController = WidgetSetupViewController.instantiate(widgetId: id ?? UUID(), delegate: self)
        viewController.hidesBottomBarWhenPushed = true
        
        router.present(viewController, animated: true) {
            // TODO: Save widget if already exists?
        }
    }
    
    func navigateToWidgetEditor(withBuilder builder: WidgetConfigurationBuilder) {
        
        let viewController = WidgetEditorViewController.instantiate(
            builder: builder,
            delegate: self
        )
        
        router.present(viewController, animated: true) {
            
        }
    }
    
    func widgetSetupViewControllerDidPressSearchApps(_ viewController: WidgetSetupViewController) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        let coordinator = SelectAppsCoordinator(router: router)
        presentChild(coordinator, animated: true)
    }
}
