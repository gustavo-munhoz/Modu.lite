//
//  TotalActivityReport.swift
//  ModuliteDeviceActivityReport
//
//  Created by André Wozniack on 27/09/24.
//

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let totalActivity = Self("Total Activity")
}

struct TotalActivityReport: DeviceActivityReportScene {
    
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (ActivityReport) -> TotalActivityView
    
    func makeConfiguration(
        representing deviceActivityResults: DeviceActivityResults<DeviceActivityData>
    ) async -> ActivityReport {
        var reportSummary = ""
        var appActivityList: [AppDeviceActivity] = []
        
        let totalDeviceActivityDuration = await deviceActivityResults.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
        
        for await activityResult in deviceActivityResults {
            reportSummary += activityResult.user.appleID?.debugDescription ?? "Unknown User"
            reportSummary += activityResult.lastUpdatedDate.description
            
            for await activitySegment in activityResult.activitySegments {
                reportSummary += activitySegment.totalActivityDuration.formatted()
                for await activityCategory in activitySegment.categories {
                    for await applicationActivity in activityCategory.applications {
                        let appName = applicationActivity.application.localizedDisplayName ?? "Unknown App"
                        let appBundleIdentifier = applicationActivity
                            .application
                            .bundleIdentifier ?? "Unknown Bundle ID"
                        let appUsageDuration = applicationActivity.totalActivityDuration
                        let appPickupsCount = applicationActivity.numberOfPickups
                        
                        let appDeviceActivity = AppDeviceActivity(
                            id: appBundleIdentifier,
                            displayName: appName,
                            duration: appUsageDuration,
                            numberOfPickups: appPickupsCount
                        )
                        
                        appActivityList.append(appDeviceActivity)
                    }
                }
            }
        }
        return ActivityReport(totalDuration: totalDeviceActivityDuration, apps: appActivityList)
    }
}
