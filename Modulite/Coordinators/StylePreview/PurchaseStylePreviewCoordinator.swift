//
//  PurchaseStylePreviewCoordinator.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import Foundation

class PurchaseStylePreviewCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    var style: WidgetStyle
    
    var onStylePurchased: (() -> Void)?
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = PurchaseStylePreviewViewController(style: style)
        router.present(viewController, animated: animated)
    }
    
    init(style: WidgetStyle, router: Router) {
        self.style = style
        self.router = router
    }
}
