//
//  WidgetSetupViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

protocol WidgetSetupViewControllerDelegate: AnyObject {
    func getPlaceholderName() -> String
    
    func widgetSetupViewControllerDidPressNext(widgetName: String)
    
    func widgetSetupViewControllerDidTapSearchApps(
        _ parentController: WidgetSetupViewController
    )
    
    func widgetSetupViewControllerDidDeselectApp(
        _ controller: WidgetSetupViewController,
        app: AppInfo
    )
    
    func widgetSetupViewControllerDidSelectWidgetStyle(
        _ controller: WidgetSetupViewController,
        style: WidgetStyle
    )
    
    func widgetSetupViewControllerDidSaveWidget(
        _ viewController: WidgetSetupViewController
    )
}

class WidgetSetupViewController: UIViewController {
    
    // MARK: - Properties
    private let setupView = WidgetSetupView()
    private var viewModel = WidgetSetupViewModel()
    
    weak var delegate: WidgetSetupViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = setupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewDependencies()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupView.updateSelectedAppsCollectionViewHeight()
    }
    
    // MARK: - Setup methods
    func setIsEditingViewToTrue() {
        setupView.setEditingMode(to: true)
    }
    
    private func configureViewDependencies() {
        setupView.setCollectionViewDelegates(to: self)
        setupView.setCollectionViewDataSources(to: self)
        setupView.setWidgetNameTextFieldDelegate(to: self)
        
        setupView.onNextButtonPressed = proceedToWidgetEditor
        setupView.onSearchButtonPressed = presentSearchModal
        setupView.onSaveButtonPressed = handleSaveButtonPress
    }
    
    private func setPlaceholderName(to name: String) {
        setupView.widgetNameTextField.placeholder = name
    }
    
    // MARK: - Actions
    func handleSaveButtonPress() {
        delegate?.widgetSetupViewControllerDidSaveWidget(self)
    }
    
    func didFinishSelectingApps(apps: [AppInfo]) {
        setSetupViewHasAppsSelected(to: !apps.isEmpty)
        viewModel.setSelectedApps(to: apps)
        
        setupView.selectedAppsCollectionView.reloadData()
    }
    
    func proceedToWidgetEditor() {
        delegate?.widgetSetupViewControllerDidPressNext(
            widgetName: setupView.getWidgetName()
        )
    }
    
    func presentSearchModal() {
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
}

extension WidgetSetupViewController {
    class func instantiate(delegate: WidgetSetupViewControllerDelegate) -> WidgetSetupViewController {
        let vc = WidgetSetupViewController()
        vc.delegate = delegate
        vc.setPlaceholderName(to: delegate.getPlaceholderName())
        
        return vc
    }
    
    func loadDataFromContent(_ content: WidgetContent) {
        setupView.widgetNameTextField.text = content.name
        viewModel.setWidgetStyle(to: content.style)
        guard let apps = content.apps.filter({ $0 != nil }) as? [AppInfo] else { return }
        
        viewModel.setSelectedApps(to: apps)
        
        setSetupViewStyleSelected(to: true)
        setSetupViewHasAppsSelected(to: true)
    }
}

extension WidgetSetupViewController: SelectedAppCollectionViewCellDelegate {
    func selectedAppCollectionViewCellDidPressDelete(_ cell: SelectedAppCollectionViewCell) {
        guard let indexPath = setupView.selectedAppsCollectionView.indexPath(for: cell) else {
            print("Could not get IndexPath for app cell")
            return
        }
        
        let app = viewModel.selectedApps[indexPath.row]
        viewModel.removeSelectedApp(app)
        delegate?.widgetSetupViewControllerDidDeselectApp(self, app: app)
        setupView.selectedAppsCollectionView.performBatchUpdates({ [weak self] in
            self?.setupView.selectedAppsCollectionView.deleteItems(at: [indexPath])
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.setupView.setNeedsLayout()
                self?.setupView.layoutIfNeeded()
            }
        })
    }
}

// MARK: - UICollectionViewDataSource
extension WidgetSetupViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section != 0 else { return 0 }
        
        switch collectionView {
        case setupView.stylesCollectionView: return viewModel.widgetStyles.count
        case setupView.selectedAppsCollectionView: return viewModel.selectedApps.count
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
        case setupView.stylesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StyleCollectionViewCell.reuseId,
                for: indexPath
            ) as? StyleCollectionViewCell else {
                fatalError("Could not dequeue StyleCollectionViewCell")
            }
            
            let style = viewModel.widgetStyles[indexPath.row]
            
            cell.setup(
                image: style.previewImage,
                title: style.name
            )
            
            cell.hasSelectionBeenMade = viewModel.isStyleSelected()
            
            if style == viewModel.selectedStyle {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            
            return cell
            
        case setupView.selectedAppsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedAppCollectionViewCell.reuseId,
                for: indexPath
            ) as? SelectedAppCollectionViewCell else {
                fatalError("Could not dequeue StyleCollectionViewCell")
            }
            
            cell.setup(with: viewModel.selectedApps[indexPath.row].name)
            
            cell.delegate = self
            
            return cell
        
        default: fatalError("Unsupported View Controller.")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SetupHeaderReusableCell.reuseId,
            for: indexPath
        ) as? SetupHeaderReusableCell else {
            fatalError("Could not dequeue SetupHeader cell.")
        }
        
        if collectionView === setupView.stylesCollectionView {
            header.setup(title: .localized(for: .widgetSetupViewStyleHeaderTitle))
            
        } else {
            header.setup(
                title: .localized(for: .widgetSetupViewAppsHeaderTitle)
            )
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension WidgetSetupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case setupView.stylesCollectionView:
            guard let style = viewModel.selectStyle(at: indexPath.row) else {
                return
            }
            
            setSetupViewStyleSelected(to: true)
            delegate?.widgetSetupViewControllerDidSelectWidgetStyle(self, style: style)
            
            collectionView.reloadData()
            
        default: return
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WidgetSetupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let text = viewModel.selectedApps[indexPath.row].name
        let font = UIFont(textStyle: .title3, weight: .semibold)
        let size = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        
        return CGSize(width: size.width + 45, height: size.height + 24)
    }
}

// MARK: - UITextFieldDelegate
extension WidgetSetupViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if string.rangeOfCharacter(from: CharacterSet.newlines) != nil {
            return false
        }
        
        let currentText = textField.text ?? ""
                
        guard let textRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > 24 {
            return false
        }
                
        return true
    }
}
