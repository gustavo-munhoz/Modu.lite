//
//  UsageActivityReport.swift
//  ModuliteDeviceActivityReport
//
//  Created by André Wozniack on 27/09/24.
//

import DeviceActivity
import SwiftUI

@main
struct UsageActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        UsageActivityReportScene { totalActivity in
            UsageActivityView(activityReport: totalActivity)
        }
    }
}
