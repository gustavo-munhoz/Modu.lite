//
//  AppUsageList.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 17/10/24.
//

import SwiftUI

struct AppUsageList: View {
    var apps: [AppDeviceActivity]
    
    var body: some View {
        let totalDuration = apps.totalDuration
        
        ForEach(apps) { app in
            let rawPercentage = totalDuration > 0 ? (app.duration / totalDuration) : 0
            let scaledPercentage = scaleLogarithmic(rawPercentage)
            
            AppUsageItem(app: app, usagePercentage: scaledPercentage)
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 24)
    }
    
    private func scaleLogarithmic(_ percentage: Double) -> Double {
        let adjustedValue = max(percentage, 0.01)
        let logValue = (log(adjustedValue + 1.015) / log(1.5)) * 1.05
        
        return min(logValue, 1.0)
    }
}

extension Array where Element == AppDeviceActivity {
    var totalDuration: TimeInterval {
        reduce(0) { $0 + $1.duration }
    }
}
