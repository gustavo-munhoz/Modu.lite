//
//  WidgetSetupViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetSetupViewController: UIViewController {
    
    // MARK: - Properties
    private let setupView = WidgetSetupView()
    private var viewModel = WidgetSetupViewModel()
    
    weak var delegate: HomeNavigationFlowDelegate?
    
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
    private func configureViewDependencies() {
        setupView.setCollectionViewDelegates(to: self)
        setupView.setCollectionViewDataSources(to: self)
        setupView.onNextButtonPressed = proceedToWidgetEditor
        setupView.onSearchButtonPressed = presentSearchModal
    }
    
    // MARK: - Actions
    func proceedToWidgetEditor() {
        let builder = viewModel.createWidgetBuilder()
        delegate?.navigateToWidgetEditor(withBuilder: builder)
    }
    
    func presentSearchModal() {
        delegate?.widgetSetupViewControllerDidPressSearchApps(self)
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
                image: style.coverImage,
                title: style.name
            )
            
            return cell
            
        case setupView.selectedAppsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedAppCollectionViewCell.reuseId,
                for: indexPath
            ) as? SelectedAppCollectionViewCell else {
                fatalError("Could not dequeue StyleCollectionViewCell")
            }
            
            cell.setup(with: viewModel.selectedApps[indexPath.row].name)
            
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

extension WidgetSetupViewController {
    class func instantiate(widgetId: UUID, delegate: HomeNavigationFlowDelegate) -> WidgetSetupViewController {
        let vc = WidgetSetupViewController()
        vc.delegate = delegate
        vc.viewModel.setWidgetId(to: widgetId)
        
        return vc
    }
}

// MARK: - UICollectionViewDelegate
extension WidgetSetupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case setupView.stylesCollectionView:
            viewModel.selectStyle(at: indexPath.row)
            
        case setupView.selectedAppsCollectionView:
            return
            
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
