//
//  WidgetBuilderCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/09/24.
//

import UIKit

class WidgetBuilderCoordinator: Coordinator {
    
    let contentBuilder = WidgetContentBuilder()
    
    var configurationBuilder: WidgetConfigurationBuilder {
        let content = contentBuilder.build()
        return WidgetConfigurationBuilder(content: content)
    }
    
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

// MARK: - WidgetSetupViewControllerDelegate
extension WidgetBuilderCoordinator: WidgetSetupViewControllerDelegate {
    func widgetSetupViewControllerDidPressNext() {
        let viewController = WidgetEditorViewController.instantiate(
            builder: configurationBuilder,
            delegate: self
        )
        
        router.present(viewController, animated: true)
    }
    
    func widgetSetupViewControllerDidSelectWidgetStyle(
        _ controller: WidgetSetupViewController,
        style: WidgetStyle
    ) {
        contentBuilder.setWidgetStyle(style)
    }
    
    func widgetSetupViewControllerDidTapSearchApps(
        _ parentController: WidgetSetupViewController
    ) {
        let router = ModalNavigationRouter(parentViewController: parentController)
        
        let coordinator = SelectAppsCoordinator(
            delegate: self,
            selectedApps: contentBuilder.getCurrentApps(),
            router: router
        )
        
        presentChild(coordinator, animated: true) { [weak self] in
            guard let self = self else { return }
            parentController.didFinishSelectingApps(
                apps: self.contentBuilder.getCurrentApps()
            )
        }
    }
}

// MARK: - SelectAppsViewControllerDelegate
extension WidgetBuilderCoordinator: SelectAppsViewControllerDelegate {
    func selectAppsViewControllerDidSelectApp(
        _ controller: SelectAppsViewController,
        didSelect app: AppInfo
    ) {
        contentBuilder.appendApp(app)
    }
    
    func selectAppsViewControllerDidDeselectApp(
        _ controller: SelectAppsViewController,
        didDeselect app: AppInfo
    ) {
        contentBuilder.removeApp(app)
    }
}

// MARK: - WidgetEditorViewControllerDelegate
extension WidgetBuilderCoordinator: WidgetEditorViewControllerDelegate {
    
}
