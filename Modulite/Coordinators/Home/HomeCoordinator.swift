//
//  HomeCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit
import WidgetKit
import WidgetStyling

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

extension HomeCoordinator: HomeViewControllerDelegate {
    func homeViewControllerDidStartWidgetCreationFlow(
        _ viewController: HomeViewController,
        type: WidgetType
    ) {
        // TODO: Check if user is plus to create AUX widget
        
        guard viewController.getCurrentMainWidgetCount() < 3 else {
            presentMaxWidgetCountAlert(viewController)
            return
        }
        
        let coordinator = WidgetBuilderCoordinator(
            router: router,
            widgetType: type,
            currentWidgetCount: viewController.getCurrentMainWidgetCount()
        )
        
        coordinator.onWidgetSave = { widget in
            viewController.registerNewWidget(widget)
        }
        
        presentChild(coordinator, animated: true)
    }
    
    func homeViewControllerDidStartWidgetEditingFlow(
        _ viewController: HomeViewController,
        widget: WidgetSchema
    ) {
        let widgetCopy = widget.clone()
        
        let coordinator = WidgetBuilderCoordinator(
            router: router,
            schema: widgetCopy
        )
        
        coordinator.onWidgetSave = { updatedWidget in
            viewController.updateMainWidget(updatedWidget)
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        coordinator.onWidgetDelete = { widgetId in
            viewController.deleteMainWidget(with: widgetId)
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        presentChild(coordinator, animated: true)
    }
    
    func homeViewControllerDidFinishOnboarding(
        _ viewController: HomeViewController
    ) {
        let router = ModalNavigationRouter(
            parentViewController: viewController,
            presentationStyle: .fullScreen
        )
        
        router.setHasSaveButton(false)
        
        let coordinator = OnboardingCompletionCoordinator(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    private func presentFeatureComingAlert(_ parentViewController: UIViewController) {
        let alert = UIAlertController(
            title: .localized(for: .comingSoonTitle),
            message: .localized(
                for: .comingSoonMessagePlural(
                    feature: .localized(for: .homeViewAuxiliarySectionHeaderTitle)
                )
            ),
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: .localized(for: .ok).uppercased(),
            style: .cancel
        )
        
        alert.addAction(okAction)
        
        parentViewController.present(alert, animated: true)
    }
    
    func presentMaxWidgetCountAlert(_ parentViewController: UIViewController) {
        let alert = UIAlertController(
            title: .localized(for: .homeViewMainWidgetsDidReachMaxCountAlertTitle),
            message: .localized(
                for: .homeViewMainWidgetsDidReachMaxCountAlertMessage
            ),
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: .localized(for: .ok).uppercased(),
            style: .cancel
        )
        
        alert.addAction(okAction)
        
        parentViewController.present(alert, animated: true)
    }
}
