//
//  AppBlockingViewController.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import UIKit

class AppBlockingViewController: UIViewController {
    
    // MARK: - Properties
    private var appBlockingView = AppBlockingView()
    private let viewModel = AppBlockingViewModel()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = appBlockingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewDependencies()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.title = .localized(for: .appBlockingViewControllerNavigationTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViewDependencies() {
        appBlockingView.setCollectionViewDelegate(to: self)
        appBlockingView.setCollectionViewDataSource(to: self)
    }
}

// MARK: - AppBlockingSessionCellDelegate
extension AppBlockingViewController: AppBlockingSessionCellDelegate {
    func appBlockingSessionCell(
        _ cell: AppBlockingSessionCell,
        didToggleTo newValue: Bool
    ) {
        
    }
}

// MARK: - UICollectionViewDataSource
extension AppBlockingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return viewModel.activeSessions.count
        case 1: return viewModel.inactiveSessions.count
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AppBlockingSessionCell.reuseId,
            for: indexPath
        ) as? AppBlockingSessionCell else {
            fatalError("Could not dequeue AppBlockingSessionCell")
        }
        
        let session = sessionFor(indexPath: indexPath)
                
        cell.setup(delegate: self, session: session)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: AppBlockingSessionHeader.reuseId,
            for: indexPath
        ) as? AppBlockingSessionHeader else {
            fatalError("Could not dequeue AppBlockingSessionHeader")
        }
        
        let title: String = .localized(
            for: indexPath.section == 0 ?
                .appBlockingViewControllerActiveTitle : .appBlockingViewControllerInactiveTitle
        )
        
        header.setup(title: title, hasButton: indexPath.section == 0)
        
        return header
    }
    
    private func sessionFor(indexPath: IndexPath) -> AppBlockingSession {
        guard indexPath.section == 0 || indexPath.section == 1 else {
            fatalError("Invalid section provided in indexPath: \(indexPath)")
        }
        
        if indexPath.section == 0 {
            return viewModel.activeSessions[indexPath.item]
        }
        
        return viewModel.inactiveSessions[indexPath.item]
    }
}

// MARK: - UICollectionViewDelegate
extension AppBlockingViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AppBlockingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 135)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
}
