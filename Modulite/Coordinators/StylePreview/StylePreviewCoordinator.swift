//
//  StylePreviewCoordinator.swift
//  Modulite
//
//  Created by André Wozniack on 31/10/24.
//

import Foundation
import WidgetStyling

class StylePreviewCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    var style: WidgetStyle?
    
    var onSelect: ((WidgetStyle) -> Void)?
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        guard let style else { return }
        
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
        guard let style else { return }
        
        onSelect?(style)
        dismiss(animated: true)
    }
}
