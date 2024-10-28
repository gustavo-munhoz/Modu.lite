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
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, AppBlockingSession>!
    
    // MARK: - Lifecycle
    override func loadView() {
        view = appBlockingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewDependencies()
        setupDataSource()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.title = .localized(for: .appBlockingViewControllerNavigationTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViewDependencies() {
        appBlockingView.setCollectionViewDelegate(to: self)
    }
    
    // MARK: - Actions
    private func didPressAddButton() {
        print("Add button pressed")
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension AppBlockingViewController {
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, AppBlockingSession>(
            collectionView: appBlockingView.sessionsCollectionView
        ) { (collectionView, indexPath, session) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AppBlockingSessionCell.reuseId,
                for: indexPath
            ) as? AppBlockingSessionCell else {
                fatalError("Could not dequeue AppBlockingSessionCell")
            }
            
            cell.setup(delegate: self, session: session)
            return cell
        }
                
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
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
            
            let hasButton = indexPath.section == 0
            
            header.setup(
                title: title,
                hasButton: hasButton,
                buttonAction: hasButton ? didPressAddButton : {}
            )
            
            return header
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AppBlockingSession>()
        snapshot.appendSections([0, 1])
                
        viewModel.sortSessions()
        
        snapshot.appendItems(viewModel.activeSessions, toSection: 0)
        snapshot.appendItems(viewModel.inactiveSessions, toSection: 1)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - AppBlockingSessionCellDelegate
extension AppBlockingViewController: AppBlockingSessionCellDelegate {
    func appBlockingSessionCell(
        _ cell: AppBlockingSessionCell,
        didToggleTo newValue: Bool
    ) {
        guard let indexPath = appBlockingView.sessionsCollectionView.indexPath(for: cell),
              let session = dataSource.itemIdentifier(for: indexPath) else { return }
                
        viewModel.updateState(of: session, to: newValue)
        applySnapshot()
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
