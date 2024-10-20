import UIKit
import DeviceActivity
import SwiftUI

protocol UsageViewControllerDelegate: AnyObject {
    func usageViewControllerShouldRequestAuth(
        _ viewController: UsageViewController,
        onCompletion: @escaping (Result<Void, Error>) -> Void
    )
}

extension UsageViewController {
    static func instantiate(
        with delegate: UsageViewControllerDelegate
    ) -> UsageViewController {
        let vc = UsageViewController()
        vc.delegate = delegate
        
        return vc
    }
}

class UsageViewController: UIHostingController<DeviceActivityReport> {
    
    // MARK: - Properties
    
    private let reportIdentifier = "TotalActivity"
    private var viewModel = UsageViewModel()
    
    weak var delegate: UsageViewControllerDelegate?

    // MARK: - Initializers
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = .whiteTurnip
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard UserPreference<ScreenTime>.shared.bool(for: .hasAuthorizedBefore) else {
            delegate?.usageViewControllerShouldRequestAuth(self) { [weak self] result in
                switch result {
                case .success:
                    self?.fetchAndDisplayActivityReport()
                case .failure:
                    break
                }
            }
            return
        }
        
        fetchAndDisplayActivityReport()
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
