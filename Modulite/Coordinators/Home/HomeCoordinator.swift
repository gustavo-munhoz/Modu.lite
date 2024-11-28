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
        let isPlusSpec = IsPlusSubscriberSpecification()
        
        if type == .auxiliary && !isPlusSpec.isSatisfied() {
            presentPlusModal(in: viewController)
            return
        }
                
        if viewController.getCurrentWidgetCount(for: .main) >= 3 && !isPlusSpec.isSatisfied() {
            presentPlusModal(in: viewController)
            return
        }
        
        let coordinator = WidgetBuilderCoordinator(
            router: router,
            widgetType: type,
            currentWidgetCount: viewController.getCurrentWidgetCount(for: type)
        )
        
        coordinator.onWidgetSave = { widget in
            viewController.registerNewWidget(widget, type: type)
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
            viewController.updateWidget(updatedWidget, type: widget.type)
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        coordinator.onWidgetDelete = {
            viewController.deleteWidget(widget, type: widget.type)
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
    
    func homeViewController(
        _ viewController: HomeViewController,
        shouldPresentOfferPlus: Bool
    ) {
        guard shouldPresentOfferPlus else { return }
        
        presentPlusModal(in: viewController)
    }
    
    private func presentPlusModal(in viewController: UIViewController) {
        let router = ModalNavigationRouter(
            parentViewController: viewController,
            presentationStyle: .fullScreen
        )
        
        router.setHasSaveButton(false)
        
        let coordinator = OfferPlusCoordinator(router: router)
        presentChild(coordinator, animated: true)
        
        return
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
