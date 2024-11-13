//
//  SubscriptionDetailsCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import UIKit

class SubscriptionDetailsCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = SubscriptionDetailsViewController.instantiate(delegate: self)
        vc.hidesBottomBarWhenPushed = true
        
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}

extension SubscriptionDetailsCoordinator: SubscriptionDetailsViewControllerDelegate {
    private func presentFeatureComingAlert(_ parentViewController: UIViewController) {
        let alert = UIAlertController(
            title: .localized(for: .comingSoonTitle),
            message: .localized(
                for: .comingSoonMessageSingular(
                    feature: .localized(for: .plus).capitalized
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
    
    func subscriptionDetailsViewControllerDidPressUpgrade(
        _ viewController: SubscriptionDetailsViewController
    ) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        router.setHasSaveButton(false)
        
        let coordinator = OfferPlusCoordinator(router: router)
        presentChild(coordinator, animated: true)
    }
}
