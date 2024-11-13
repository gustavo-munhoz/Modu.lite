//
//  OfferPlusCoordinator.swift
//  Modulite
//
//  Created by André Wozniack on 13/11/24.
//

import Foundation

class OfferPlusCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        print("Present Offer Plus")
        
        let vc = OfferPlusViewController()
        router.present(vc, animated: animated)
    }
    
}
