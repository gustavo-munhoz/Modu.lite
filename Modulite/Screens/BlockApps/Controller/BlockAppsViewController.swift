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
        return SectionType.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let sectionType = SectionType(rawValue: section)!
        switch sectionType {
        case .active:
            return sessions.filter { $0.isActive }.count
        case .inactive:
            return sessions.filter { !$0.isActive }.count
        }
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
        
        let sectionType = SectionType(rawValue: indexPath.section)!
        let session: AppBlockingSession

        if sectionType == .active {
            session = sessions.filter { $0.isActive }[indexPath.item]
        } else {
            session = sessions.filter { !$0.isActive }[indexPath.item]
        }

        cell.indexPath = indexPath
        cell.isActive = session.isActive
        cell.blockingSession.text = session.name
        cell.timeLabel.text = session.time
        
        if session.appsBlocked == 0 {
            if session.categoriesBlocked == 1 {
                cell.appsBlockedLabel.text = "\(session.categoriesBlocked) categorie blocked"
            } else {
                cell.appsBlockedLabel.text = "\(session.categoriesBlocked) categories blocked"
            }
            
        } else {
            if session.appsBlocked == 1 {
                cell.appsBlockedLabel.text = "\(session.appsBlocked) app blocked"
            }
            cell.appsBlockedLabel.text = "\(session.appsBlocked) apps blocked"
        }
        
        cell.delegate = self

        if sectionType == .inactive && sessions.filter({ $0.isActive }).count >= 1 {
            cell.toggleSwitch.isEnabled = false
        } else {
            cell.toggleSwitch.isEnabled = true
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = SectionType(rawValue: indexPath.section)!
        let session: AppBlockingSession

        if sectionType == .active {
            session = sessions.filter { $0.isActive }[indexPath.item]
        } else {
            session = sessions.filter { !$0.isActive }[indexPath.item]
        }

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
        let sectionType = SectionType(rawValue: index.section)!
        var session: AppBlockingSession

        if sectionType == .active {
            session = sessions.filter { $0.isActive }[index.item]
        } else {
            session = sessions.filter { !$0.isActive }[index.item]
        }
        
        guard let originalIndex = sessions.firstIndex(where: { $0.id == session.id }) else { return }

        if isActive {
            for i in 0..<sessions.count {
                if sessions[i].isActive && i != originalIndex {
                    sessions[i].isActive = false
                    sessions[i].deactivateBlock()
                }
            }
            sessions[originalIndex].isActive = true
            sessions[originalIndex].activateBlock()
        } else {
            sessions[originalIndex].isActive = false
            sessions[originalIndex].deactivateBlock()
        }

        sessions = viewModel.blockingSessions

        let activeSessions = sessions.filter { $0.isActive }
        let inactiveSessions = sessions.filter { !$0.isActive }
        
        blockAppsView.activeCollectionView.performBatchUpdates({
            if sectionType == .active {
                let newIndexPath = IndexPath(item: inactiveSessions.count - 1, section: SectionType.inactive.rawValue)
                blockAppsView.activeCollectionView.moveItem(at: index, to: newIndexPath)
            } else {
                let newIndexPath = IndexPath(item: activeSessions.count - 1, section: SectionType.active.rawValue)
                blockAppsView.activeCollectionView.moveItem(at: index, to: newIndexPath)
            }
        }, completion: { _ in
            self.blockAppsView.activeCollectionView.reloadData()
        })
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
            
            let indexPath = IndexPath(
                item: index,
                section: session.isActive ? SectionType.active.rawValue : SectionType.inactive.rawValue
            )
            
            blockAppsView.activeCollectionView.performBatchUpdates({
                blockAppsView.activeCollectionView.reloadItems(at: [indexPath])
            }, completion: { _ in
                self.blockAppsView.activeCollectionView.reloadData()
            })
        } else {
            viewModel.createBlockingSession(session)
            sessions = viewModel.blockingSessions
            
            let activeSessions = sessions.filter { $0.isActive }
            let inactiveSessions = sessions.filter { !$0.isActive }
            
            blockAppsView.activeCollectionView.performBatchUpdates(
                {
                    if !activeSessions.isEmpty {
                        let newIndexPath = IndexPath(
                            item: activeSessions.count - 1,
                            section: SectionType.active.rawValue
                        )
                        blockAppsView.activeCollectionView.insertItems(at: [newIndexPath])
                    } else if !inactiveSessions.isEmpty {
                        let newIndexPath = IndexPath(
                            item: inactiveSessions.count - 1,
                            section: SectionType.inactive.rawValue
                        )
                        blockAppsView.activeCollectionView.insertItems(at: [newIndexPath])
                    }
                },
                completion: { _ in
                self.blockAppsView.activeCollectionView.reloadData()
            })
        }
    }
}
