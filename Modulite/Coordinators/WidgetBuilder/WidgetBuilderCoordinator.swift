//
//  WidgetBuilderCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/09/24.
//

import UIKit

class WidgetBuilderCoordinator: Coordinator {
    
    // MARK: - Properties

    var children: [Coordinator] = []
    var router: Router
    
    let contentBuilder = WidgetContentBuilder()
    var configurationBuilder: WidgetConfigurationBuilder {
        let content = contentBuilder.build()
        
        if let config = injectedConfiguration {
            return WidgetConfigurationBuilder(
                content: content,
                configuration: config
            )
        }
        
        return WidgetConfigurationBuilder(content: content)
    }
    
    var currentWidgetCount: Int
    
    var onWidgetSave: ((ModuliteWidgetConfiguration) -> Void)?
    
    var injectedConfiguration: ModuliteWidgetConfiguration?
    
    // MARK: - Initializers
    
    init(router: Router) {
        self.currentWidgetCount = 0
        self.router = router
    }
    
    init(router: Router, currentWidgetCount: Int) {
        self.currentWidgetCount = currentWidgetCount
        self.router = router
    }
    
    init(router: Router, configuration: ModuliteWidgetConfiguration) {
        self.currentWidgetCount = 0
        self.router = router
        
        injectedConfiguration = configuration
        injectedConfiguration?.modules.sort(by: { $0.index < $1.index })
        
        contentBuilder.setWidgetName(configuration.name!)
        contentBuilder.setWidgetStyle(configuration.widgetStyle!)
        
        for module in injectedConfiguration!.modules {
            guard let appName = module.appName,
                  let url = module.associatedURLScheme else { continue }
            
            guard let appInfo = CoreDataPersistenceController.shared.fetchAppInfo(
                named: appName,
                urlScheme: url.absoluteString
            ) else { continue }
            
            contentBuilder.appendApp(appInfo)
        }
    }
    
    // MARK: - Presenting
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = WidgetSetupViewController.instantiate(delegate: self)
        
        if injectedConfiguration != nil {
            viewController.loadDataFromContent(contentBuilder.build())
        }
        
        viewController.hidesBottomBarWhenPushed = true
         
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}

// MARK: - WidgetSetupViewControllerDelegate
extension WidgetBuilderCoordinator: WidgetSetupViewControllerDelegate {
    func getPlaceholderName() -> String {
        .localized(
            for: .widgetSetupViewMainWidgetNamePlaceholder(number: currentWidgetCount + 1)
        )
    }
    
    func widgetSetupViewControllerDidPressNext(widgetName: String) {
        contentBuilder.setWidgetName(widgetName)
        
        let viewController = WidgetEditorViewController.instantiate(
            builder: configurationBuilder,
            delegate: self
        )
        
        if injectedConfiguration != nil {
            viewController.loadDataFromBuilder(configurationBuilder)
        }
        
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
    func widgetEditorViewController(
        _ viewController: WidgetEditorViewController,
        didSave widget: ModuliteWidgetConfiguration
    ) {
        onWidgetSave?(widget)
        dismiss(animated: true)
    }
}
