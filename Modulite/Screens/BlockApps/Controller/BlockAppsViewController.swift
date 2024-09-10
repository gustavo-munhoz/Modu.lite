import UIKit


class BlockAppsViewController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    BlockAppsCellDelegate {

    private let blockAppsView = BlockAppsView()

    // Lista única de sessões
    private var sessions: [BlockingSession] = []
    
    override func loadView() {
        view = blockAppsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        blockAppsView.activeCollectionView.delegate = self
        blockAppsView.activeCollectionView.dataSource = self
        blockAppsView.activeCollectionView.register(
            BlockAppsCollectionViewCell.self,
            forCellWithReuseIdentifier: BlockAppsCollectionViewCell.reusId
        )
        
        setupInitialData()
    }

    // Configuração inicial dos dados
    private func setupInitialData() {
        sessions = [
            BlockingSession(name: "Session 1", time: "09:00 - 12:00", appsBlocked: 5, isActive: true),
            BlockingSession(name: "Session 2", time: "14:00 - 16:00", appsBlocked: 3, isActive: true),
            BlockingSession(name: "Session 3", time: "18:00 - 20:00", appsBlocked: 2, isActive: false),
            BlockingSession(name: "Session 4", time: "18:00 - 20:00", appsBlocked: 2, isActive: false),
            BlockingSession(name: "Session 5", time: "18:00 - 20:00", appsBlocked: 2, isActive: false)
        ]
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
        let session: BlockingSession

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

        let session: BlockingSession
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

struct BlockingSession {
    let name: String
    let time: String
    let appsBlocked: Int
    var isActive: Bool
}
