//
//  WidgetEditorViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit
import TipKit
import WidgetStyling

extension Notification.Name {
    static let widgetEditorDidFinishOnboarding = Notification.Name("widgetEditorDidFinishOnboarding")
}

protocol WidgetEditorViewControllerDelegate: AnyObject {
    func widgetEditorViewController(
        _ viewController: WidgetEditorViewController,
        didSave widget: WidgetSchema
    )
    
    func widgetEditorViewController(
        _ viewController: WidgetEditorViewController,
        didDeleteWithId id: UUID
    )
    
    func widgetEditorViewControllerDidPressBack(
        _ viewController: WidgetEditorViewController
    )
    
    func widgetEditorViewControllerDidPressLayoutInfo(
        _ viewController: WidgetEditorViewController
    )
    
    func widgetEditorViewControllerDidPressWallpaperInfo(
        _ viewController: WidgetEditorViewController
    )
}

class WidgetEditorViewController: UIViewController {
    static let didDragModule = Tips.Event(id: "didDragModule")
    static let didEditModule = Tips.Event(id: "didEditModule")
    
    // MARK: - Properties
    private(set) var editorView = WidgetEditorView()
    private(set) var viewModel: WidgetEditorViewModel!
    
    weak var delegate: WidgetEditorViewControllerDelegate?
    var strategy: WidgetTypeStrategy!
    
    private var isCreatingNewWidget: Bool = true
    
    private(set) var isOnboarding: Bool = false
    
    private var dragModuleTip = DragModuleTip()
    private var editModuleTip = EditModuleTip()
    private var downloadWallpapersTip = DownloadWallpapersTip()
    private var dragModuleObservationTask: Task<Void, Never>?
    private var editModuleObservationTask: Task<Void, Never>?
    private var wallpapersObservationTask: Task<Void, Never>?
    private weak var tipPopoverController: TipUIPopoverViewController?
    
    var hasCompletedDrag: Bool = false
    var hasCompletedEdit: Bool = false
    
    // MARK: - Lifecycle
    override func loadView() {
        view = editorView
        editorView.setCollectionViewDelegates(to: self)
        editorView.setCollectionViewDataSources(to: self)
        editorView.setScrollViewDelegate(to: self)
        
        setViewActions()
        
        let background = viewModel.getWidgetBackground()
        
        editorView.setWidgetBackground(to: background)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViewSizesWithStrategy()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isOnboarding else { return }
        
        setupTipObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        breakdownTipObservers()
    }
    
    // MARK: - Setup
    func setupViewSizesWithStrategy() {
        editorView.setupCollectionViewLayout(with: strategy)
        
        editorView.setupLayoutCollectionViewSize(
            strategy.getEditorLayoutCollectionViewSize()
        )
        
        editorView.setupModuleStyleItemSize(
            strategy.getEditorModuleStyleItemSize()
        )
    }
    
    func setIsOnboarding(_ isOnboarding: Bool) {
        self.isOnboarding = isOnboarding
    }
    
    func setViewActions() {
        editorView.onDownloadWallpaperButtonTapped = handleDownloadWallpaperTouch
        editorView.onSaveButtonTapped = handleSaveWidgetButtonTouch
        editorView.onDeleteButtonTapped = handleDeleteWidgetButtonTouch
        
        editorView.setLayoutInfoButtonAction { [weak self] in
            guard let self = self else { return }
            self.delegate?.widgetEditorViewControllerDidPressLayoutInfo(self)
        }
        
        editorView.setWallpaperInfoButtonAction { [weak self] in
            guard let self = self else { return }
            self.delegate?.widgetEditorViewControllerDidPressWallpaperInfo(self)
        }
    }
    
    private func setupNavigationBar() {
        guard isCreatingNewWidget else { return }
        
        navigationItem.backAction = UIAction { [weak self] _ in
            self?.handleBackButtonPress()
        }
    }
    
    private func setupTipObservers() {
        dragModuleObservationTask = dragModuleObservationTask ?? createObservationTask(
            for: dragModuleTip,
            sourceItem: editorView.widgetLayoutCollectionView
        )
        
        editModuleObservationTask = editModuleObservationTask ?? createObservationTask(
            for: editModuleTip,
            sourceItem: editorView.widgetLayoutCollectionView
        )
        
        wallpapersObservationTask = wallpapersObservationTask ?? createObservationTask(
            for: downloadWallpapersTip,
            sourceItem: editorView.downloadWallpaperButton
        )
    }
    
    private func breakdownTipObservers() {
        dragModuleObservationTask?.cancel()
        dragModuleObservationTask = nil
        
        editModuleObservationTask?.cancel()
        editModuleObservationTask = nil
        
        wallpapersObservationTask?.cancel()
        wallpapersObservationTask = nil
    }
    
    // MARK: - Onboarding
    private func createObservationTask(
        for tip: any Tip,
        sourceItem: UIPopoverPresentationControllerSourceItem
    ) -> Task<Void, Never>? {
        Task { @MainActor in
            for await shouldDisplay in tip.shouldDisplayUpdates where shouldDisplay {
                presentTip(tip, sourceItem: sourceItem)
            }
        }
    }
    
    private func presentTip(
        _ tip: any Tip,
        sourceItem: any UIPopoverPresentationControllerSourceItem
    ) {
        dismissCurrentTip()
        
        let popoverController = TipUIPopoverViewController(
            tip,
            sourceItem: sourceItem
        )
        
        popoverController.popoverPresentationController?.passthroughViews = [editorView]
        
        present(popoverController, animated: true)
        tipPopoverController = popoverController
    }
    
    func dismissCurrentTip(_ animated: Bool = true) {
        if presentedViewController is TipUIPopoverViewController {
            dismiss(animated: animated)
            tipPopoverController = nil
        }
    }
    
    // MARK: - Actions
    @objc private func handleBackButtonPress() {
        delegate?.widgetEditorViewControllerDidPressBack(self)
    }
    
    func setIsEditingViewToTrue() {
        editorView.setEditingMode(to: true)
        isCreatingNewWidget = false
    }
    
    private func handleDownloadWallpaperTouch() {
        dismissCurrentTip()
        
        viewModel.saveWallpaperImageToPhotos { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    self.presentWallpaperSaveAlert(success: true)
                    self.disableWallpaperDownloadButton()
                case .failure(let error):
                    self.presentWallpaperSaveAlert(success: false, error: error)
                }
            }
        }
    }

    private func disableWallpaperDownloadButton() {
        editorView.downloadWallpaperButton.isEnabled = false
    }

    private func presentWallpaperSaveAlert(success: Bool, error: Error? = nil) {
        let titleKey: WidgetEditorLocalizedTexts = success ?
            .widgetEditorWallpaperAlertSuccessTitle : .widgetEditorWallpaperAlertErrorTitle
        
        let title = String.localized(for: titleKey)
        let message: String
        
        if success {
            message = .localized(for: WidgetEditorLocalizedTexts.widgetEditorWallpaperAlertSuccessMessage)
            
        } else if let error = error as? WallpaperSaveError {
            message = error.localizedDescription
            
        } else {
            message = .localized(for: .unknownErrorOcurred)
        }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: .localized(for: .gotIt),
                style: .default,
                handler: nil
            )
        )
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleSaveWidgetButtonTouch() {
        clearSelectedModuleCell()
        
        guard let widget = viewModel.saveWidget(
            from: editorView.widgetLayoutCollectionView
        ) else { return }
        
        delegate?.widgetEditorViewController(self, didSave: widget)
        
        if isOnboarding {
            NotificationCenter.default.post(name: .widgetEditorDidFinishOnboarding, object: nil)
        }
    }
    
    func handleDeleteWidgetButtonTouch() {
        presentWidgetDeletionWarning()
    }
    
    private func presentWidgetDeletionWarning() {
        let alert = UIAlertController(
            title: .localized(
                for: .widgetEditorViewDeleteAlertTitle
            ),
            message: .localized(for: .widgetEditorViewDeleteAlertMessage),
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(
            title: .localized(for: .delete),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            
            let id = self.viewModel.getWidgetId()
            delegate?.widgetEditorViewController(self, didDeleteWithId: id)
        }
        
        let cancelAction = UIAlertAction(
            title: .localized(for: .cancel),
            style: .cancel
        )
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension WidgetEditorViewController {
    class func instantiate(
        builder: WidgetSchemaBuilder,
        delegate: WidgetEditorViewControllerDelegate,
        strategy: WidgetTypeStrategy
    ) -> WidgetEditorViewController {
        let vc = WidgetEditorViewController()
                
        vc.viewModel = WidgetEditorViewModel(widgetBuider: builder)
        vc.delegate = delegate
        vc.strategy = strategy
        
        return vc
    }
    
    func loadDataFromBuilder(_ builder: WidgetSchemaBuilder) {
        viewModel = WidgetEditorViewModel(widgetBuider: builder)
    }
}
