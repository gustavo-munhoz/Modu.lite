//
//  UsageActivityReportScene.swift
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
    let content: (ActivityReport) -> UsageActivityView
    
    /// Generates the configuration for the activity report based on the provided device activity results.
    ///
    /// - Parameter deviceActivityResults: The results of device activity data.
    /// - Returns: An `ActivityReport` containing usage statistics and application activity for today.
    func makeConfiguration(
        representing deviceActivityResults: DeviceActivityResults<DeviceActivityData>
    ) async -> ActivityReport {
        
        let calendar = Calendar.current
        let dateIntervals = setupDateIntervals(calendar: calendar, now: .now)
        
        var dailyUsage: [Date: TimeInterval] = [:]
        var appUsage: [Date: [AppDeviceActivity]] = [:]
        
        // Iterate over each activity segment to accumulate usage data.
        for await activitySegment in deviceActivityResults.flatMap({ $0.activitySegments }) {
            await processActivitySegment(
                activitySegment,
                calendar: calendar,
                dateIntervals: dateIntervals,
                dailyUsage: &dailyUsage,
                appUsage: &appUsage
            )
        }
        
        let averageTimeLastWeek = calculateAverageTime(
            for: dailyUsage,
            in: dateIntervals.last7DaysInterval
        )
        
        return ActivityReport(
            dailyUsage: dailyUsage,
            averageTimeLastWeek: averageTimeLastWeek,
            appUsage: appUsage
        )
    }
    
    /// Sets up the date intervals required for calculating usage statistics.
    ///
    /// - Parameters:
    ///   - calendar: The calendar used for date calculations.
    ///   - now: The current date and time.
    /// - Returns: A tuple containing the interval for the last seven days and the start of today.
    private func setupDateIntervals(
        calendar: Calendar,
        now: Date
    ) -> (last7DaysInterval: DateInterval, startOfToday: Date) {
        let startOfToday: Date = .today
        
        guard let startOf7DaysAgo = calendar.date(byAdding: .day, value: -7, to: startOfToday) else {
            return (DateInterval(), startOfToday)
        }
        
        let last7DaysInterval = DateInterval(start: startOf7DaysAgo, end: startOfToday)
        return (last7DaysInterval, startOfToday)
    }
    
    /// Processes an individual activity segment, updating usage statistics and tracking app activities per day.
    ///
    /// - Parameters:
    ///   - activitySegment: The activity segment to process.
    ///   - calendar: The calendar used for date comparisons.
    ///   - dateIntervals: The date intervals defining the last seven days and the start of today.
    ///   - dailyUsage: An inout dictionary accumulating daily usage times.
    ///   - appUsage: An inout dictionary accumulating app activities per day.
    private func processActivitySegment(
        _ activitySegment: DeviceActivityData.ActivitySegment,
        calendar: Calendar,
        dateIntervals: (last7DaysInterval: DateInterval, startOfToday: Date),
        dailyUsage: inout [Date: TimeInterval],
        appUsage: inout [Date: [AppDeviceActivity]]
    ) async {
        let segmentStartDate = activitySegment.dateInterval.start
        let segmentStartOfDay = calendar.startOfDay(for: segmentStartDate)
        
        // Accumulate daily usage for the last 7 days.
        if dateIntervals.last7DaysInterval.contains(segmentStartDate) {
            dailyUsage[segmentStartOfDay, default: 0] += activitySegment.totalActivityDuration
        }
        
        // Accumulate app usage for the last 7 days.
        guard dateIntervals.last7DaysInterval.contains(segmentStartDate) else { return }
        
        let apps = activitySegment.categories.flatMap { $0.applications }
        let appActivities = await apps.map {
            AppDeviceActivity(
                id: $0.application.bundleIdentifier ?? "Unknown Bundle ID",
                token: $0.application.token,
                displayName: $0.application.localizedDisplayName ?? "Unknown App",
                duration: $0.totalActivityDuration,
                numberOfPickups: $0.numberOfPickups
            )
        }.collect()
        
        appUsage[segmentStartOfDay, default: []].append(contentsOf: appActivities)
    }
    
    private func calculateAverageTime(
        for dailyUsage: [Date: TimeInterval],
        in last7DaysInterval: DateInterval
    ) -> TimeInterval {
        
        let totalTimeLast7Days = dailyUsage
            .filter { last7DaysInterval.contains($0.key) }
            .reduce(0) { $0 + $1.value }
        
        return totalTimeLast7Days / 7
    }
}
