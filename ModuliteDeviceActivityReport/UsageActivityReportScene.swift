//
//  TotalActivityReport.swift
//  ModuliteDeviceActivityReport
//
//  Created by André Wozniack on 27/09/24.
//

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    static let totalActivity = Self("TotalActivity")
}

struct UsageActivityReportScene: DeviceActivityReportScene {
        
    let context: DeviceActivityReport.Context = .totalActivity
    let content: (ActivityReport) -> TotalActivityView
    
    func makeConfiguration(
        representing deviceActivityResults: DeviceActivityResults<DeviceActivityData>
    ) async -> ActivityReport {
        let totalDeviceActivityDuration = await deviceActivityResults
            .flatMap { $0.activitySegments }
            .reduce(0, { $0 + $1.totalActivityDuration })
        
        let appActivityList = Array(
            Set(
                await deviceActivityResults
                .flatMap { $0.activitySegments }
                .flatMap { $0.categories }
                .flatMap { $0.applications }
                .map {
                    AppDeviceActivity(
                        id: $0.application.bundleIdentifier ?? "Unknown Bundle ID",
                        displayName: $0.application.localizedDisplayName ?? "Unknown App",
                        duration: $0.totalActivityDuration,
                        numberOfPickups: $0.numberOfPickups
                    )
                }
                .collect()
            )
        ).sorted(by: { $0.duration > $1.duration })
        
        return ActivityReport(totalDuration: totalDeviceActivityDuration, apps: appActivityList)
    }
}
