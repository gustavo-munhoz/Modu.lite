import UIKit
import DeviceActivity
import SwiftUI

class UsageViewController: UIHostingController<DeviceActivityReport> {

    private let reportIdentifier = "TotalActivity"
    private var viewModel = UsageViewModel()

    init() {
        super.init(
            rootView: DeviceActivityReport(
                DeviceActivityReport.Context(reportIdentifier),
                filter: DeviceActivityFilter()
            )
        )
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        fetchAndDisplayActivityReport()
        view.backgroundColor = .whiteTurnip
    }
    
    // MARK: - Setup Methods

    private func setupNavigationBar() {
        navigationItem.title = .localized(for: .usageViewControllerNavigationTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func updateNavigationBarUponLoad() {
        safeAreaRegions = SafeAreaRegions()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Data Fetching

    private func fetchAndDisplayActivityReport() {
        Task {
            do {
                try await viewModel.requestAuthorization()
                let reportView = await createDeviceActivityReport()
                await MainActor.run {
                    self.rootView = reportView
                    
                    self.updateNavigationBarUponLoad()
                }
                
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

    // MARK: - Error Handling

    private func handleAuthorizationError(_ error: Error) async {
        await MainActor.run {
            let alert = UIAlertController(
                title: NSLocalizedString("Authorization Error", comment: ""),
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: .localized(for: .ok).uppercased(),
                    style: .default
                )
            )
            present(alert, animated: true)
        }
    }
}
