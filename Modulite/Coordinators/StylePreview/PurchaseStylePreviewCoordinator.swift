//
//  PurchaseStylePreviewCoordinator.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import Foundation
import WidgetStyling

class PurchaseStylePreviewCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    var style: WidgetStyle?
    
    var onBuy: ((WidgetStyle) -> Void)?
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        guard let style else { return }
        
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
        guard let style else { return }
        
        onBuy?(style)
        dismiss(animated: true)
    }
}
