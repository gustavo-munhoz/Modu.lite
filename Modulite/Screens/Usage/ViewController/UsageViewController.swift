import UIKit
import DeviceActivity
import FamilyControls
import SwiftUI

class UsageViewController: UIViewController {
    
    private var usageViewModel = UsageViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authCenter = AuthorizationCenter.shared
        
        Task {
            do {
                try await authCenter.requestAuthorization(for: .individual)
                
                let context: DeviceActivityReport.Context = .init("TotalActivity")
                
                let reportView = DeviceActivityReport(context)
                let hostingController = UIHostingController(rootView: reportView)
                
                addChild(hostingController)
                hostingController.view.frame = view.bounds
                view.addSubview(hostingController.view)
                hostingController.didMove(toParent: self)
                
            } catch {
                print("Authorization Error")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup methods
    private func setupNavigationBar() {
        navigationItem.title = .localized(for: .usageViewControllerNavigationTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
