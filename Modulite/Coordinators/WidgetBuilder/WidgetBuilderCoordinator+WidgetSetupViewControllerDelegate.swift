//
//  WidgetBuilderCoordinator+WidgetSetupViewControllerDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit

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
        
        viewController.setIsOnboarding(isOnboarding)
        
        if injectedConfiguration != nil {
            viewController.loadDataFromBuilder(configurationBuilder)
            viewController.navigationItem.title = .localized(for: .widgetEditingNavigationTitle)
            viewController.setIsEditingViewToTrue()
        }
        
        router.present(viewController, animated: true)
    }
    
    func widgetSetupViewControllerDidSelectWidgetStyle(
        _ controller: WidgetSetupViewController,
        style: WidgetStyle
    ) {
        contentBuilder.setWidgetStyle(style)
        
        if let config = injectedConfiguration {
            config.randomizeWithNewStyle(style)
        }
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
            
            parentController.setSetupViewHasAppsSelected(
                to: !self.contentBuilder.getCurrentApps().isEmpty
            )
            
            parentController.didFinishSelectingApps(
                apps: self.contentBuilder.getCurrentApps()
            )
        }
    }
    
    func widgetSetupViewControllerDidDeselectApp(
        _ controller: WidgetSetupViewController,
        app: AppInfo
    ) {
        contentBuilder.removeApp(app)
        
        if contentBuilder.getCurrentApps().isEmpty {
            controller.setSetupViewHasAppsSelected(to: false)
        }
        
        guard let config = injectedConfiguration else { return }
        guard let idx = config.modules.firstIndex(where: { $0.appName == app.name }) else {
            print("Tried to deselect an app that is not in injected configuration.")
            return
        }
        
        config.modules.replace(
            at: idx,
            with: ModuleConfiguration.empty(
                style: config.widgetStyle!,
                at: idx
            )
        )
    }
    
    func widgetSetupViewControllerDidPressBack(
        _ viewController: WidgetSetupViewController,
        didMakeChanges: Bool
    ) {
        if didMakeChanges {
            presentBackAlertForViewController(
                viewController,
                message: .localized(for: .widgetEditingUnsavedChangesAlertMessage)
            ) { [weak self] in
                self?.dismiss(animated: true)
            }
            
            return
        }
        
        dismiss(animated: true)
    }
    
    func widgetSetupViewControllerShouldPresentPreview(
        _ viewController: WidgetSetupViewController,
        for style: WidgetStyle
    ) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        router.setHasSaveButton(false)
        
        let coordinator = StylePreviewCoordinator(style: style, router: router)
        
        presentChild(coordinator, animated: true) {
            viewController.selectStyle(style)
        }
    }
    
    func widgetSetupViewControllerShouldPresentPurchasePreview(
        _ viewController: WidgetSetupViewController,
        for style: WidgetStyle
    ) {
        
        let router = ModalNavigationRouter(parentViewController: viewController)
        router.setHasSaveButton(false)
        
        let coordinator = PurchaseStylePreviewCoordinator(style: style, router: router)
        
        presentChild(coordinator, animated: true) {
            viewController.selectStyle(style)
        }
    }
}
