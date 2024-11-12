//
//  WidgetBuilderCoordinator+WidgetSetupViewControllerDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit
import WidgetStyling

extension WidgetBuilderCoordinator: WidgetSetupViewControllerDelegate {

    func getWidgetCount() -> Int {
        currentWidgetCount
    }
    
    func widgetSetupViewControllerDidPressNext(widgetName: String) {
        contentBuilder.setWidgetName(widgetName)
        
        guard let builder = try? configurationBuilder else { return }
        
        let viewController = WidgetEditorViewController.instantiate(
            builder: builder,
            delegate: self
        )
        
        viewController.setIsOnboarding(isOnboarding)
        
        if existingSchema != nil {
            viewController.loadDataFromBuilder(builder)
            viewController.navigationItem.title = String.localized(for: .widgetEditingNavigationTitle)
            viewController.setIsEditingViewToTrue()
        }
        
        router.present(viewController, animated: true)
    }
    
    func widgetSetupViewControllerDidSelectWidgetStyle(
        _ controller: WidgetSetupViewController,
        style: WidgetStyle
    ) {
        contentBuilder.setWidgetStyle(style)
        
        if let existingSchema {
            existingSchema.changeWidgetStyle(to: style)
        }
    }
    
    func widgetSetupViewControllerDidTapSearchApps(
        _ parentController: WidgetSetupViewController
    ) {
        let router = ModalNavigationRouter(parentViewController: parentController)
        
        let coordinator = SelectAppsCoordinator(
            delegate: self,
            selectedApps: contentBuilder.getCurrentApps(),
            maxApps: parentController.strategy.type.maxModules,
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
        app: AppData
    ) {
        do { try contentBuilder.removeApp(app) } catch { return }
        
        if contentBuilder.getCurrentApps().isEmpty {
            controller.setSetupViewHasAppsSelected(to: false)
        }
        
        guard let existingSchema else { return }
        guard let pos = existingSchema.modules.firstIndex(where: { $0.appName == app.name }) else {
            print("Tried to deselect an app that is not in injected configuration.")
            return
        }
        
        let emptyModule = existingSchema.widgetStyle.getEmptyModuleStyle(for: .main)
        
        existingSchema.modules.replace(
            at: pos,
            with: WidgetModule(
                style: emptyModule,
                position: pos,
                appName: nil,
                urlScheme: nil,
                color: emptyModule.defaultColor
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
        
        coordinator.onSelect = { style in
            viewController.selectStyle(style)
        }
        
        presentChild(coordinator, animated: true)
    }
    
    func widgetSetupViewControllerShouldPresentPurchasePreview(
        _ viewController: WidgetSetupViewController,
        for style: WidgetStyle
    ) {
        
        let router = ModalNavigationRouter(parentViewController: viewController)
        router.setHasSaveButton(false)
        
        let coordinator = PurchaseStylePreviewCoordinator(style: style, router: router)
        
        coordinator.onBuy = { style in
            viewController.handleStylePurchase(for: style)
        }
        
        presentChild(coordinator, animated: true) {
            viewController.selectStyle(style)
        }
    }
}
