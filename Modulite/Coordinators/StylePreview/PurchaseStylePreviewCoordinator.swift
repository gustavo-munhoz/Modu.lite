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
    var style: WidgetStyle = WidgetStyleFactory.styleForKey(.analog)
    
    var onBuy: ((WidgetStyle) -> Void)?
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = PurchaseStylePreviewViewController(style: style)
        vc.delegate = self
        
        router.present(vc, animated: animated)
    }
    
    init(router: Router) {
        self.router = router
    }
    
    init(style: WidgetStyle, router: Router) {
        self.style = style
        self.router = router
    }
}

extension PurchaseStylePreviewCoordinator: PurchaseStylePreviewControllerDelegate {
    func purchaseStylePreviewViewControllerDidPressUseStyle(
        _ viewController: PurchaseStylePreviewViewController
    ) {
        onBuy?(style)
        dismiss(animated: true)
    }
}
