import UIKit
import DeviceActivity
import SwiftUI

class UsageViewController: UIHostingController<UsageView> {
    
    // MARK: - Properties
    
    private let reportIdentifier = "TotalActivity"

    // MARK: - Initializers
    init() {
        super.init(rootView: UsageView())
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = .whiteTurnip
    }
    
    // MARK: - Setup Methods

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        safeAreaRegions = SafeAreaRegions()
    }
}
