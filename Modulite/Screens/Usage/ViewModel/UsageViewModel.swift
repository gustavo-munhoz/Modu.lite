//
//  UsageViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 27/09/24.
//

import Foundation
import FamilyControls
import DeviceActivity
import SwiftUI

class UsageViewModel: ObservableObject {
    private let reportIdentifier = "TotalActivity"
    
    @Published var isAuthorized = FamilyControlsManager.shared.isAuthorized
    
    func createDeviceActivityReport() -> DeviceActivityReport {
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
    
    func performAuth() {
        guard UserPreference<ScreenTime>.shared.bool(for: .hasSetPreferenceBefore) else { return }
        
        FamilyControlsManager.shared.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isAuthorized = true
                case .failure:
                    self.isAuthorized = false
                }
            }
        }
    }
}
