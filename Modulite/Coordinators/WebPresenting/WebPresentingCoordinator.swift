//
//  WebPresentingCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/11/24.
//

import UIKit

class WebPresentingCoordinator: Coordinator {
    /// Child coordinators managed by this coordinator.
    var children: [Coordinator] = []
    
    /// The router used to present view controllers.
    let router: Router
    
    private let url: URL?
    
    /// Initializes a new instance of `BlockAppsCoordinator` with a router.
    /// - Parameter router: The router that will handle presentation and dismissal of view controllers.
    init(router: Router) {
        self.url = nil
        self.router = router
    }
    
    init(url: URL, router: Router) {
        self.url = url
        self.router = router
    }
    
    /// Presents the block apps view controller using the associated router.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the block apps view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        guard let url else { return }

        let vc = WebPresentingViewController()
        vc.hidesBottomBarWhenPushed = true
        
        vc.setURL(url)
        router.present(vc, animated: animated, onDismiss: onDismiss)
    }
}
