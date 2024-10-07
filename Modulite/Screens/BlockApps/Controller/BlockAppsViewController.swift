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
        let createBlockingSessionVC = NewBlockingSessionViewController.instantiate(with: self)

        let navController = UINavigationController(rootViewController: createBlockingSessionVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }

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
        cell.appsBlockedLabel.text = "\(session.appsBlocked) apps blocked"
        cell.delegate = self

        if sectionType == .inactive && sessions.filter({ $0.isActive }).count >= 1 {
            cell.toggleSwitch.isEnabled = false
        } else {
            cell.toggleSwitch.isEnabled = true
        }

        return cell
    }

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
        
        // Atualiza o data source
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
        _ viewController: NewBlockingSessionViewController,
        didCreate session: AppBlockingSession
    ) {
        viewModel.createBlockingSession(session)
        sessions = viewModel.blockingSessions

        let activeSessions = sessions.filter { $0.isActive }
        let indexPath = IndexPath(item: activeSessions.count - 1, section: SectionType.active.rawValue)

        blockAppsView.activeCollectionView.performBatchUpdates({
            self.blockAppsView.activeCollectionView.insertItems(at: [indexPath])
        }, completion: { _ in
            self.blockAppsView.activeCollectionView.reloadData()
        })
    }
}
