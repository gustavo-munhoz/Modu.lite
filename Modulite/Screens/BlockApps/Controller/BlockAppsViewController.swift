import UIKit
import SwiftUI

class BlockAppsViewController:
    UIViewController,
        UICollectionViewDelegate,
        UICollectionViewDataSource,
        BlockAppsCellDelegate {

    private let blockAppsView = BlockAppsView()
    private var sessions: [AppBlockingSession] = []
    private var viewModel: BlockAppsViewModel = BlockAppsViewModel()

    private(set) lazy var selectAppsButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "+"
        button.style = .plain
        button.target = self
        button.action = #selector(createBlockingSession)
        
        return button
    }()
    
    override func loadView() {
        view = blockAppsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FamilyControlsManager.shared.requestAuthorization()
        
        blockAppsView.activeCollectionView.delegate = self
        blockAppsView.activeCollectionView.dataSource = self
        blockAppsView.activeCollectionView.register(
            BlockAppsCollectionViewCell.self,
            forCellWithReuseIdentifier: BlockAppsCollectionViewCell.reusId
        )
        navigationItem.rightBarButtonItem = selectAppsButton

        setupInitialData()
    }
    
    private func setupInitialData() {
        sessions = viewModel.blockingSessions
    }
    
    @objc private func createBlockingSession() {
        let createBlockingSessionVC = BlockingSessionViewController.instantiate(with: self)

        let navController = UINavigationController(rootViewController: createBlockingSessionVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Collection View Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sessions.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BlockAppsCollectionViewCell.reusId,
            for: indexPath
        ) as? BlockAppsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let session = sessions[indexPath.item]

        cell.indexPath = indexPath
        cell.isActive = session.isActive
        cell.blockingSession.text = session.name
        cell.timeLabel.text = session.time
        
        if session.appsBlocked == 0 {
            if session.categoriesBlocked == 1 {
                cell.appsBlockedLabel.text = "\(session.categoriesBlocked) category blocked"
            } else {
                cell.appsBlockedLabel.text = "\(session.categoriesBlocked) categories blocked"
            }
        } else {
            if session.appsBlocked == 1 {
                cell.appsBlockedLabel.text = "\(session.appsBlocked) app blocked"
            } else {
                cell.appsBlockedLabel.text = "\(session.appsBlocked) apps blocked"
            }
        }
        
        cell.delegate = self
        cell.toggleSwitch.isEnabled = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let session = sessions[indexPath.item]
        openEditSessionView(for: session)
    }
    
    private func openEditSessionView(for session: AppBlockingSession) {
        let editBlockingSessionVC = BlockingSessionViewController.instantiate(with: self)
        editBlockingSessionVC.viewModel.loadSession(session)
        editBlockingSessionVC.isEditingSession = true
        editBlockingSessionVC.currentSession = session

        let navController = UINavigationController(rootViewController: editBlockingSessionVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }

    // MARK: - Switch Logic
    func didToggleSwitch(at index: IndexPath, isActive: Bool) {
        sessions[index.item].isActive = isActive
        
        if isActive {
            sessions[index.item].activateBlock()
        } else {
            sessions[index.item].deactivateBlock()
        }

        blockAppsView.activeCollectionView.reloadItems(at: [index])
    }

}

// MARK: - CreateBlockingSessionViewControllerDelegate
extension BlockAppsViewController: BlockingSessionViewControllerDelegate {
    func createBlockingSessionViewController(
        _ viewController: BlockingSessionViewController,
        didCreate session: AppBlockingSession
    ) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            blockAppsView.activeCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            viewModel.createBlockingSession(session)
            sessions = viewModel.blockingSessions
            blockAppsView.activeCollectionView.insertItems(at: [IndexPath(item: sessions.count - 1, section: 0)])
        }
    }
}
