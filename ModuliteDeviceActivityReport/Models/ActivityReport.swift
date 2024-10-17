//
//  ActivityReport.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 15/10/24.
//

import Foundation

struct ActivityReport {
    let dailyUsage: [Date: TimeInterval]
    let averageTimeLastWeek: TimeInterval
    let appUsage: [Date: [AppDeviceActivity]]
    
    func formattedTime(for date: Date) -> String {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return dailyUsage[startOfDay]?.formattedWithUnits() ?? "-"
    }
    
    var formattedAverageTimeLastWeek: String {
        averageTimeLastWeek.formattedWithUnits()
    }
    
    func relevantApps(for date: Date) -> [AppDeviceActivity] {
        (appUsage[date] ?? [])
            .filter { $0.duration > 60}
            .sorted(by: { $0.duration > $1.duration })
    }
}
