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
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = StylePreviewViewController(style: style)
        router.present(viewController, animated: animated)
    }
    
    init(router: Router) {
        self.router = router
    }
    
    init(style: WidgetStyle, router: Router) {
        self.style = style
        self.router = router
    }
}
