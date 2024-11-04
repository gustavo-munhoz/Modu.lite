//
//  StylePreviewCoordinator.swift
//  Modulite
//
//  Created by André Wozniack on 31/10/24.
//

import Foundation

class StylePreviewCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    var style: WidgetStyle = WidgetStyleFactory.styleForKey(.analog)
    
    var onSelect: ((WidgetStyle) -> Void)?
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = StylePreviewViewController(style: style)
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

extension StylePreviewCoordinator: StylePreviewViewControllerDelegate {
    func stylePreviewViewControllerDidPressUseStyle(
        _ viewController: StylePreviewViewController
    ) {
        onSelect?(style)
        dismiss(animated: true)
    }
}
