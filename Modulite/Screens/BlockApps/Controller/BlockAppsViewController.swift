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

    }
    
    @objc private func createBlockingSession() {
        let createBlockingSessionVC = CreateBlockingSessionViewController.instantiate(with: self)

        
        let navController = UINavigationController(rootViewController: createBlockingSessionVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }
    
    private func setupInitialData() {
        sessions = viewModel.blockingSessions
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

        if sectionType == .inactive && sessions.filter({ $0.isActive }).count >= 4 {
            cell.toggleSwitch.isEnabled = false
        } else {
            cell.toggleSwitch.isEnabled = true
        }

        return cell
    }

    func didToggleSwitch(at index: IndexPath, isActive: Bool) {
        let sectionType = SectionType(rawValue: index.section)!

        let session: AppBlockingSession
        if sectionType == .active {
            session = sessions.filter { $0.isActive }[index.item]
        } else {
            session = sessions.filter { !$0.isActive }[index.item]
        }
        
        guard let originalIndex = sessions.firstIndex(where: { $0.name == session.name }) else { return }
        
        if sectionType == .inactive && sessions.filter({ $0.isActive }).count >= 4 {
            print("A seção ativa está cheia, não é possível mover mais itens para a seção ativa.")
            return
        }
        
        sessions[originalIndex].isActive = isActive
        
        blockAppsView.activeCollectionView.performBatchUpdates({
            if sectionType == .active {
                let newIndexPath = IndexPath(
                    item: sessions.filter { !$0.isActive }.count - 1,
                    section: SectionType.inactive.rawValue
                )
                
                blockAppsView.activeCollectionView.moveItem(at: index, to: newIndexPath)
            } else {
                let activeCount = sessions.filter { $0.isActive }.count
                let newIndexPath = IndexPath(
                    item: activeCount - 1,
                    section: SectionType.active.rawValue
                )

                blockAppsView.activeCollectionView.moveItem(at: index, to: newIndexPath)
            }
        }, completion: { _ in
            self.blockAppsView.activeCollectionView.reloadSections(IndexSet(integer: SectionType.active.rawValue))
            self.blockAppsView.activeCollectionView.reloadSections(IndexSet(integer: SectionType.inactive.rawValue))
        })
    }
}

// MARK: - CreateBlockingSessionViewControllerDelegate
extension BlockAppsViewController: BlockingSessionViewControllerDelegate {
    func createBlockingSessionViewController(
        _ viewController: CreateBlockingSessionViewController,
        didCreate session: AppBlockingSession
    ) {
        let row = viewModel.createBlockingSession(session)
        let indexPath = IndexPath(item: row, section: SectionType.active.rawValue)
        
        blockAppsView.activeCollectionView.performBatchUpdates { [weak self] in
            self?.blockAppsView.activeCollectionView.insertItems(at: [indexPath])
        }
    }
    
}
