//
//  WidgetSetupViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetSetupViewController: UIViewController {
    
    private let setupView = WidgetSetupView()    
    private var viewModel = WidgetSetupViewModel()
    
    override func loadView() {
        view = setupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView.setCollectionViewDelegates(to: self)
        setupView.setCollectionViewDataSources(to: self)
        setupView.onNextButtonPressed = viewModel.proceedToWidgetEditor
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
        case setupView.selectedAppsCollectionView: return viewModel.apps.count
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
            
            cell.setup(with: viewModel.widgetStyles[indexPath.row].coverImage)
            return cell
            
        case setupView.selectedAppsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedAppCollectionViewCell.reuseId,
                for: indexPath
            ) as? SelectedAppCollectionViewCell else {
                fatalError("Could not dequeue StyleCollectionViewCell")
            }
            
            cell.setup(with: viewModel.apps[indexPath.row].name)
            
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
                title: .localized(for: .widgetSetupViewAppsHeaderTitle),
                containsSearchBar: true,
                searchBarDelegate: self
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
            viewModel.selectStyle(at: indexPath.row)
            
        case setupView.selectedAppsCollectionView:
            viewModel.selectApp(at: indexPath.row)
            
        default: return
        }
    }
}

// MARK: - UISearchBarDelegate
extension WidgetSetupViewController: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterApps(for: searchText)
        
        UIView.performWithoutAnimation {
            // Making textFieldDummy the first responder seems to be necessary to not 
            // dismiss the keyboard when updating the collection view data.
            // I thought updating the section would fix it, but apparently it didn't.
            setupView.textFieldDummy.becomeFirstResponder()
            setupView.selectedAppsCollectionView.reloadSections(IndexSet(integer: 1))
            searchBar.becomeFirstResponder()
        }
    }
}

extension WidgetSetupViewController {
    class func instantiate(widgetId: UUID, delegate: HomeNavigationFlowDelegate) -> WidgetSetupViewController {
        let vc = WidgetSetupViewController()
        vc.viewModel.setWidgetId(to: widgetId)
        vc.viewModel.setDelegate(to: delegate)
        
        return vc
    }
}
