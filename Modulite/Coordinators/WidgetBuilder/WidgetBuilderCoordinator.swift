//
//  WidgetBuilderCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/09/24.
//

import UIKit

class WidgetBuilderCoordinator: Coordinator {
    let builder = WidgetConfigurationBuilder()
    
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = WidgetSetupViewController.instantiate(widgetId: UUID(), delegate: self)
        viewController.hidesBottomBarWhenPushed = true
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}

extension WidgetBuilderCoordinator: WidgetSetupViewControllerDelegate {
    func widgetSetupViewControllerDidSelectWidgetStyle(
        _ controller: WidgetSetupViewController,
        style: WidgetStyle
    ) {
        builder.setWidgetStyle(style)
    }
    
    func widgetSetupViewControllerDidTapSearchApps(
        _ parentController: WidgetSetupViewController
    ) {
        let router = ModalNavigationRouter(parentViewController: parentController)
        
        let coordinator = SelectAppsCoordinator(
            delegate: self,
            selectedApps: builder.getCurrentApps(),
            router: router
        )
        
        presentChild(coordinator, animated: true) { [weak self] in
            guard let self = self else { return }
            parentController.didFinishSelectingApps(
                apps: self.builder.getCurrentApps()
            )
        }
    }
}

extension WidgetBuilderCoordinator: SelectAppsViewControllerDelegate {
    func selectAppsViewControllerDidSelectApp(
        _ controller: SelectAppsViewController,
        didSelect app: AppInfo
    ) {
        builder.addSelectedApp(for: app)
    }
    
    func selectAppsViewControllerDidDeselectApp(
        _ controller: SelectAppsViewController,
        didDeselect app: AppInfo
    ) {
        builder.removeSelectedApp(for: app)
    }
}
