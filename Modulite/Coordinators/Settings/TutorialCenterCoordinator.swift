//
//  TutorialCenterCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialCenterCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = TutorialCenterViewController.instantiate(delegate: self)
        vc.hidesBottomBarWhenPushed = true
        
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}

extension TutorialCenterCoordinator: TutorialCenterViewControllerDelegate {
    private func presentFeatureComingAlert(_ parentViewController: UIViewController) {
        let alert = UIAlertController(
            title: .localized(for: .comingSoonTitle),
            message: .localized(
                for: .comingSoonMessagePlural(
                    feature: .localized(for: .tutorialVideos)
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
    
    func tutorialCenterDidPressCreateWidget(_ viewController: TutorialCenterViewController) {
        let coordinator = TutorialCoordinator<TutorialCreateWidgetViewController>(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    func tutorialCenterDidPressCreateWidgetVideo(_ viewController: TutorialCenterViewController) {
        presentFeatureComingAlert(viewController)
    }
    
    func tutorialCenterDidPressEditOrDeleteWidget(_ viewController: TutorialCenterViewController) {
        let coordinator = TutorialCoordinator<TutorialEditWidgetViewController>(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    func tutorialCenterDidPressAddWidget(_ viewController: TutorialCenterViewController) {
        let coordinator = TutorialCoordinator<TutorialAddWidgetViewController>(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    func tutorialCenterDidPressAddWidgetVideo(_ viewController: TutorialCenterViewController) {
        presentFeatureComingAlert(viewController)
    }
    
    func tutorialCenterDidPressSetWallpaper(_ viewController: TutorialCenterViewController) {
        let coordinator = TutorialCoordinator<TutorialWallpaperViewController>(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    func tutorialCenterDidPressChangeWallpaperVideo(_ viewController: TutorialCenterViewController) {
        presentFeatureComingAlert(viewController)
    }
}
