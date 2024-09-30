import UIKit
import DeviceActivity
import Combine

class UsageViewController: UIViewController {
    private var usageView = UsageView()
    private var usageViewModel = UsageViewModel()
    private var cancellables: Set<AnyCancellable> = []


    override func loadView() {
        view = usageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        usageView.appUsageTableView.dataSource = self
//        usageView.appUsageTableView.delegate = self
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "0h 0m"
    }
}
