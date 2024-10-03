//
//  AppBlockingSession.swift
//  Modulite
//
//  Created by André Wozniack on 03/10/24.
//

import Foundation
import FamilyControls

class AppBlockingSession {
    var name: String?
    var selection: FamilyActivitySelection!
    var blockingType: BlockType?
    var isAllDay: Bool?
    var startsAt: DateComponents?
    var endsAt: DateComponents?
    var daysOfWeek: [WeekDay] = []
    var isActive: Bool
    
    var time: String {
        let startFormatted = formatTime(from: startsAt)
        let endFormatted = formatTime(from: endsAt)
        return "\(startFormatted) - \(endFormatted)"
    }
    
    var appsBlocked: Int {
        return selection.applications.count
    }
    
    init(
        name: String,
        selection: FamilyActivitySelection,
        blockingType: BlockType,
        isAllDay: Bool,
        startsAt: DateComponents,
        endsAt: DateComponents,
        daysOfWeek: [WeekDay] = [],
        isActive: Bool
    ) {
        self.name = name
        self.selection = selection
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
