//
//  WidgetEditorViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

protocol WidgetEditorViewControllerDelegate: AnyObject {
    func widgetEditorViewController(
        _ viewController: WidgetEditorViewController,
        didSave widget: ModuliteWidgetConfiguration
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
    
    // MARK: - Properties
    private(set) var editorView = WidgetEditorView()
    private(set) var viewModel: WidgetEditorViewModel!
    
    weak var delegate: WidgetEditorViewControllerDelegate?
    
    private var isCreatingNewWidget: Bool = true
    
    // MARK: - Lifecycle
    override func loadView() {
        view = editorView
        editorView.setCollectionViewDelegates(to: self)
        editorView.setCollectionViewDataSources(to: self)
        
        setViewActions()
        
        if let background = viewModel.getWidgetBackground() {
            editorView.setWidgetBackground(to: background)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    // MARK: - Setup
    
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
    
    func setupNavigationBar() {
        guard isCreatingNewWidget else { return }
        
        navigationItem.backAction = UIAction { [weak self] _ in
            self?.handleBackButtonPress()
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
        do {
            try viewModel.saveWallpaperImageToPhotos()
            presentWallpaperSaveAlert(success: true)
            disableWallpaperDownloadButton()
            
        } catch {
            presentWallpaperSaveAlert(success: false)
        }
    }
    
    private func disableWallpaperDownloadButton() {
        editorView.downloadWallpaperButton.isEnabled = false
    }
    
    private func presentWallpaperSaveAlert(success: Bool) {
        // TODO: Implement alert messages
        let alert = UIAlertController(
            title: success ? "Success" : "Error",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func handleSaveWidgetButtonTouch() {
        clearSelectedModuleCell()
        
        let widget = viewModel.saveWidget(from: editorView.widgetLayoutCollectionView)
        delegate?.widgetEditorViewController(self, didSave: widget)
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
        builder: WidgetConfigurationBuilder,
        delegate: WidgetEditorViewControllerDelegate
    ) -> WidgetEditorViewController {
        let vc = WidgetEditorViewController()
        
        vc.viewModel = WidgetEditorViewModel(widgetBuider: builder)
        vc.delegate = delegate
        
        return vc
    }
    
    func loadDataFromBuilder(_ builder: WidgetConfigurationBuilder) {
        viewModel = WidgetEditorViewModel(widgetBuider: builder)
    }
}
