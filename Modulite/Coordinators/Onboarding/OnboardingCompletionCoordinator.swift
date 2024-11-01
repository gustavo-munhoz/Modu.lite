//
//  OnboardingCompletionCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 31/10/24.
//

import UIKit

class OnboardingCompletionCoordinator: Coordinator {
    /// Child coordinators managed by this coordinator.
    var children: [Coordinator] = []
    
    /// The router used to present view controllers.
    let router: Router
    
    /// Initializes a new instance of `BlockAppsCoordinator` with a router.
    /// - Parameter router: The router that will handle presentation and dismissal of view controllers.
    init(router: Router) {
        self.router = router
    }
    
    /// Presents the block apps view controller using the associated router.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the block apps view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = OnboardingTutorialsViewController()
        vc.delegate = self
        
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}

extension OnboardingCompletionCoordinator: OnboardingTutorialsControllerDelegate {
    func onboardingTutorialsViewController(
        _ viewController: OnboardingTutorialsViewController,
        didPressPresent tutorial: OnboardingTutorialType
    ) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        router.setHasSaveButton(false)
        
        switch tutorial {
        case .wallpaper:
            let coordinator = TutorialCoordinator<TutorialWallpaperViewController>(router: router)
            presentChild(coordinator, animated: true)
            
        case .widget:
            let coordinator = TutorialCoordinator<TutorialAddWidgetViewController>(router: router)
            presentChild(coordinator, animated: true)
        }
    }
}
