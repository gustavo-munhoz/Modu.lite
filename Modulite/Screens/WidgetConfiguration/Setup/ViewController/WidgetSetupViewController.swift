//
//  WidgetSetupViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit
import TipKit
import WidgetStyling

class WidgetSetupViewController: UIViewController {
    static let didSelectWidgetStyle = Tips.Event(id: "didSelectWidgetStyle")
    static let didSelectApps = Tips.Event(id: "didSelectApps")
    
    // MARK: - Properties
    let setupView = WidgetSetupView()
    var viewModel = WidgetSetupViewModel()
    
    weak var delegate: WidgetSetupViewControllerDelegate?
    var strategy: WidgetTypeStrategy!
    
    var purchaseManager = PurchaseManager.shared
    
    private var isEditingWidget: Bool = false
    
    var didMakeChangesToWidget: Bool = false
    
    var isOnboarding: Bool = false {
        didSet {
            if isOnboarding {
                viewModel = WidgetSetupViewModel(isOnboarding: true)
            }
        }
    }
    
    private var selectWidgetStyleTip = SelectWidgetStyleTip()
    private var selectAppsTip = SelectAppsTip()
    private var proceedToEditorTip = ProceedToEditorTip()
    private var styleTipObservationTask: Task<Void, Never>?
    private var selectAppsTipObservationTask: Task<Void, Never>?
    private var proceedTipObservationTask: Task<Void, Never>?
    private weak var tipPopoverController: TipUIPopoverViewController?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = setupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewDependencies()
        setupNavigationBar()
        setupViewSizesWithStrategy()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupView.updateSelectedAppsCollectionViewHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToSelectedStyle()

        if isOnboarding { setupTipObservers() }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        teardownTipObservers()
    }
    
    // MARK: - Setup methods
    
    private func setupViewSizesWithStrategy() {
        setupView.setupSetupSelectAppsTitle(
            maxsAppsCount: strategy.type.maxModules
        )
        
        setupView.setupStyleCollectionViewHeight(
            strategy.getSetupStyleCollectionViewHeight()
        )
        
        setupView.setupStyleCellHeight(
            strategy.getSetupStyleCellHeight()
        )
    }
    
    private func setupTipObservers() {
        styleTipObservationTask = styleTipObservationTask ?? createObservationTask(
            for: selectWidgetStyleTip,
            sourceItem: setupView.stylesCollectionView
        )
        
        selectAppsTipObservationTask = selectAppsTipObservationTask ?? createObservationTask(
            for: selectAppsTip,
            sourceItem: setupView.searchAppsButton
        )
        
        proceedTipObservationTask = proceedTipObservationTask ?? createObservationTask(
            for: proceedToEditorTip,
            sourceItem: setupView.nextViewButton
        )
    }
    
    private func teardownTipObservers() {
        styleTipObservationTask?.cancel()
        styleTipObservationTask = nil
        
        selectAppsTipObservationTask?.cancel()
        selectAppsTipObservationTask = nil
        
        proceedTipObservationTask?.cancel()
        proceedTipObservationTask = nil
    }
    
    func setupNavigationBar() {
        guard isEditingWidget else { return }
        
        navigationItem.backAction = UIAction { [weak self] _ in
            self?.handleBackButtonPress()
        }
    }
    
    func setToWidgetEditingMode() {
        isEditingWidget = true
    }
    
    private func configureViewDependencies() {
        setupView.setCollectionViewDelegates(to: self)
        setupView.setCollectionViewDataSources(to: self)
        setupView.setWidgetNameTextFieldDelegate(to: self)
        
        setupView.onNextButtonPressed = proceedToWidgetEditor
        setupView.onSearchButtonPressed = presentSearchModal
    }
    
    private func setPlaceholderName(to name: String) {
        setupView.setupWidgetNamePlaceholder(name)
    }
    
    // MARK: - Actions
    @objc func handleBackButtonPress() {
        delegate?.widgetSetupViewControllerDidPressBack(
            self,
            didMakeChanges: didMakeChangesToWidget
        )
    }
    
    func didFinishSelectingApps(apps: [AppData]) {
        setSetupViewHasAppsSelected(to: !apps.isEmpty)
        viewModel.setSelectedApps(to: apps)
        
        setupView.selectedAppsCollectionView.reloadData()
        
        if !apps.isEmpty, isOnboarding {
            Self.didSelectApps.sendDonation()
        }
    }
    
    func proceedToWidgetEditor() {
        if isOnboarding { dismissCurrentTip() }
        
        delegate?.widgetSetupViewControllerDidPressNext(
            self,
            widgetName: setupView.getWidgetName()
        )
    }
    
    func presentSearchModal() {
        if isOnboarding && tipPopoverController != nil {
            dismissCurrentTip()
        }
        
        delegate?.widgetSetupViewControllerDidTapSearchApps(self)
    }
    
    func setSetupViewStyleSelected(to value: Bool) {
        setupView.isStyleSelected = value
        setupView.updateButtonConfig()
    }
    
    func setSetupViewHasAppsSelected(to value: Bool) {
        setupView.hasAppsSelected = value
        setupView.updateButtonConfig()
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
        
        popoverController.popoverPresentationController?.passthroughViews = [setupView]
        
        present(popoverController, animated: true)
        tipPopoverController = popoverController
    }
    
    private func dismissCurrentTip(_ animated: Bool = true) {
        if presentedViewController is TipUIPopoverViewController {
            dismiss(animated: animated)
            tipPopoverController = nil
        }
    }
    
    private func handlePurchaseCompleted(for productId: String) {
        if let index = viewModel.widgetStyles.firstIndex(where: { $0.identifier == productId }) {
            viewModel.widgetStyles[index].isPurchased = true
            setupView.stylesCollectionView.reloadData()
        }
    }
}

extension WidgetSetupViewController {
    class func instantiate(
        delegate: WidgetSetupViewControllerDelegate,
        widgetType: WidgetType
    ) -> WidgetSetupViewController {
        let vc = WidgetSetupViewController()
        vc.delegate = delegate
        
        vc.strategy = (widgetType == .main) ? MainWidgetStrategy() : AuxWidgetStrategy()
        
        let count = delegate.getWidgetCount() + 1
        let namePlaceholder: String = .localized(
            for: widgetType == .main
            ? .widgetSetupViewMainWidgetNamePlaceholder(number: count)
            : .widgetSetupViewAuxWidgetNamePlaceholder(number: count)
        )
        
        vc.setPlaceholderName(to: namePlaceholder)
        
        return vc
    }
    
    func loadDataFromContent(_ content: WidgetContent) {
        setupView.widgetNameTextField.text = content.name
        viewModel.setWidgetStyle(to: content.style)
        guard let apps = content.apps.filter({ $0 != nil }) as? [AppData] else { return }
        
        viewModel.setSelectedApps(to: apps)
        
        setSetupViewStyleSelected(to: true)
        setSetupViewHasAppsSelected(to: true)
    }
}
