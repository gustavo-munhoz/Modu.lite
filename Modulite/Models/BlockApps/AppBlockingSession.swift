//
//  AppBlockingSession.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import Foundation
import ManagedSettings
import DeviceActivity
import FamilyControls

enum BlockingType: String, Codable {
    case scheduled
    case alwaysOn
}

class AppBlockingSession: ObservableObject {
    
    var id = UUID()
    var sessionName: String = ""
    @Published var activitySelection: FamilyActivitySelection
    var blockingType: BlockingType
    var isAllDay: Bool
    var startsAt: DateComponents = .init(hour: 0, minute: 0)
    var endsAt: DateComponents = .init(hour: 0, minute: 0)
    var daysOfWeek: [Int] = []
    
    var lastTimeToggled: Date = .now
    
    var appsCount: Int {
        return activitySelection.applications.count
    }
    
    var categoriesCount: Int {
        return activitySelection.categories.count
    }
    
    var webDomainsCount: Int {
        return activitySelection.webDomains.count
    }
    
    var totalSelectionCount: Int {
        appsCount + categoriesCount + webDomainsCount
    }
    
    var activityName: DeviceActivityName {
        return DeviceActivityName(self.id.uuidString)
    }
    
    var isActive: Bool
    
    var time: String {
        let startFormatted = formatTime(from: startsAt)
        let endFormatted = formatTime(from: endsAt)
        return "\(startFormatted) - \(endFormatted)"
    }
    
    var blockManager: BlockManager?
    
    init(
        id: UUID = UUID(),
        sessionName: String = "",
        activitySelection: FamilyActivitySelection = .init(),
        blockingType: BlockingType = .scheduled,
        isAllDay: Bool = false,
        startsAt: DateComponents = .init(),
        endsAt: DateComponents = .init(),
        daysOfWeek: [Int] = [],
        isActive: Bool = false
    ) {
        self.id = id
        self.sessionName = sessionName
        self.activitySelection = activitySelection
        self.blockingType = blockingType
        self.isAllDay = isAllDay
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.daysOfWeek = daysOfWeek
        self.isActive = isActive
    }
    
    private func formatTime(from components: DateComponents?) -> String {
        guard let hour = components?.hour, let minute = components?.minute else {
            return "00:00"
        }
        return String(format: "%02d:%02d", hour, minute)
    }
}

extension AppBlockingSession: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AppBlockingSession, rhs: AppBlockingSession) -> Bool {
        return lhs.id == rhs.id
    }
}
