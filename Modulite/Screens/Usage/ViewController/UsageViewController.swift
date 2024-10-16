import UIKit
import DeviceActivity
import FamilyControls
import SwiftUI

class UsageViewController: UIViewController {
    
    private let reportIdentifier = "TotalActivity"
    
    private var viewModel = UsageViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fetchAndDisplayActivityReport()
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
    
    private func fetchAndDisplayActivityReport() {
        Task {
            do {
                try await viewModel.requestAuthorization()
                
                let reportView = await createDeviceActivityReport()
                await displayReport(reportView)
                
            } catch {
                await handleAuthorizationError(error)
            }
        }
    }
    
    private func createDeviceActivityReport() async -> DeviceActivityReport {
        let calendar = Calendar.current
        let now = Date()
        
        guard let startOf7DaysAgo = calendar.date(
            byAdding: .day,
            value: -7,
            to: calendar.startOfDay(for: now)
        ) else {
            fatalError("Failed to calculate start date for 7 days ago.")
        }
        
        let filter = DeviceActivityFilter(
            segment: .daily(
                during: DateInterval(start: startOf7DaysAgo, end: now)
            )
        )
        
        let context = DeviceActivityReport.Context(reportIdentifier)
        let reportView = DeviceActivityReport(context, filter: filter)
        return reportView
    }
    
    private func displayReport(_ reportView: DeviceActivityReport) async {
        let hostingController = UIHostingController(rootView: reportView)
        hostingController.view.backgroundColor = .whiteTurnip
        
        await MainActor.run {
            addChild(hostingController)
            hostingController.view.frame = view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
        }
    }
    
    private func handleAuthorizationError(_ error: Error) async {
        await MainActor.run {
            let alert = UIAlertController(
                title: "Authorization Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
