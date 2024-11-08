//
//  WidgetBuilderCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/09/24.
//

import UIKit
import WidgetStyling

class WidgetBuilderCoordinator: Coordinator {
    
    // MARK: - Properties

    var children: [Coordinator] = []
    var router: Router
    
    let contentBuilder = WidgetContentBuilder(type: .main)
    var configurationBuilder: WidgetSchemaBuilder {
        get throws {
            let content = try contentBuilder.build()
            
            if let existingSchema {
                return WidgetSchemaBuilder(schema: existingSchema)
            }
            
            return WidgetSchemaBuilder(content: content)
        }
    }
    
    var currentWidgetCount: Int
    
    var onWidgetSave: ((WidgetSchema) -> Void)?
    var onWidgetDelete: ((UUID) -> Void)?
    
    var existingSchema: WidgetSchema?
    
    var shouldHideBackButton = false
    var isOnboarding = false
    
    // MARK: - Initializers
    
    init(router: Router) {
        self.currentWidgetCount = 0
        self.router = router
    }
    
    init(router: Router, currentWidgetCount: Int) {
        self.currentWidgetCount = currentWidgetCount
        self.router = router
    }
    
    init(router: Router, schema: WidgetSchema) {
        self.currentWidgetCount = 0
        self.router = router
        
        existingSchema = schema
        existingSchema?.modules.sort(by: { $0.position < $1.position })
        
        contentBuilder.setWidgetName(schema.name)
        contentBuilder.setWidgetStyle(schema.widgetStyle)
        
        for module in existingSchema!.modules {
            guard let appName = module.appName,
                  let url = module.urlScheme else { continue }
            
            guard let appInfo = CoreDataPersistenceController.shared.fetchAppData(
                named: appName,
                urlScheme: url.absoluteString
            ) else { continue }
            
            try? contentBuilder.appendApp(appInfo)
        }
    }
    
    // MARK: - Optional Setup
    func setHidesBackButton(_ hidesBackButton: Bool) {
        shouldHideBackButton = hidesBackButton
    }
    
    func setIsOnboarding(_ isOnboarding: Bool) {
        self.isOnboarding = isOnboarding
    }
    
    // MARK: - Presenting
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = WidgetSetupViewController.instantiate(delegate: self)
                
        viewController.navigationItem.setHidesBackButton(
            shouldHideBackButton,
            animated: false
        )
        
        viewController.isOnboarding = isOnboarding
        
        if existingSchema != nil {
            guard let content = try? contentBuilder.build() else { return }
            viewController.navigationItem.title = .localized(for: .widgetEditingNavigationTitle)
            viewController.loadDataFromContent(content)
            viewController.setToWidgetEditingMode()
        }
        
        viewController.hidesBottomBarWhenPushed = true
         
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
    
    func presentBackAlertForViewController(
        _ parentViewController: UIViewController,
        message: String,
        discardAction: @escaping (() -> Void)
    ) {
        let alert = UIAlertController(
            title: .localized(for: .widgetEditingUnsavedChangesAlertTitle),
            message: message,
            preferredStyle: .alert
        )
        
        let keepEditingAction = UIAlertAction(
            title: .localized(for: .widgetEditingUnsavedChangesAlertActionKeepEditing),
            style: .cancel
        )
        
        let discardChangesAction = UIAlertAction(
            title: .localized(for: .widgetEditingUnsavedChangesAlertActionDiscard),
            style: .destructive
        ) { _ in
            discardAction()
        }
        
        alert.addAction(keepEditingAction)
        alert.addAction(discardChangesAction)
        
        parentViewController.present(alert, animated: true)
    }
}

// MARK: - SelectAppsViewControllerDelegate
extension WidgetBuilderCoordinator: SelectAppsViewControllerDelegate {
    func selectAppsViewControllerDidSelectApp(
        _ controller: SelectAppsViewController,
        didSelect app: AppData
    ) {
        do { try contentBuilder.appendApp(app) }
        catch { return }
        
        guard let existingSchema else { return }
        guard let pos = existingSchema.modules.firstIndex(where: { $0.appName == nil }) else {
            print("Tried selecting an app with maximum count selected.")
            return
        }
        
        let randomModule = existingSchema.widgetStyle.getRandomModuleStyle(for: .main)
        
        existingSchema.modules.replace(
            at: pos,
            with: WidgetModule(
                style: randomModule,
                position: pos,
                appName: app.name,
                urlScheme: app.urlScheme,
                color: randomModule.defaultColor
            )
        )
    }
    
    func selectAppsViewControllerDidDeselectApp(
        _ controller: SelectAppsViewController,
        didDeselect app: AppData
    ) {
        do { try contentBuilder.removeApp(app) }
        catch { return }
        
        guard let existingSchema else {return }
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
}

// MARK: - WidgetEditorViewControllerDelegate
extension WidgetBuilderCoordinator: WidgetEditorViewControllerDelegate {
    func widgetEditorViewController(
        _ viewController: WidgetEditorViewController,
        didSave widget: WidgetSchema
    ) {
        onWidgetSave?(widget)
        dismiss(animated: true)
    }
    
    func widgetEditorViewController(
        _ viewController: WidgetEditorViewController,
        didDeleteWithId id: UUID
    ) {
        onWidgetDelete?(id)
        dismiss(animated: true)
    }
    
    func widgetEditorViewControllerDidPressBack(
        _ viewController: WidgetEditorViewController
    ) {
        presentBackAlertForViewController(
            viewController,
            message: .localized(for: .widgetCreatingUnsavedChangesAlertMessage)
        ) { [weak self] in
            self?.router.dismissTopViewController(animated: true)
        }
    }
    
    func widgetEditorViewControllerDidPressLayoutInfo(
        _ viewController: WidgetEditorViewController
    ) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        router.setHasSaveButton(false)
        
        let coordinator = TutorialCoordinator<TutorialCreateWidgetViewController>(router: router)
        
        presentChild(coordinator, animated: true)
    }
    
    func widgetEditorViewControllerDidPressWallpaperInfo(
        _ viewController: WidgetEditorViewController
    ) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        router.setHasSaveButton(false)
        
        let coordinator = TutorialCoordinator<TutorialWallpaperViewController>(router: router)
        
        presentChild(coordinator, animated: true)
    }
}
