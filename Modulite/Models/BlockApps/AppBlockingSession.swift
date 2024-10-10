//
//  AppBlockingSession.swift
//  Modulite
//
//  Created by André Wozniack on 03/10/24.
//

import Foundation
import FamilyControls
import DeviceActivity

class AppBlockingSession {
    var id = UUID()
    var name: String?
    var selection: FamilyActivitySelection!
    var blockingType: BlockType?
    var isAllDay: Bool?
    var startsAt: DateComponents?
    var endsAt: DateComponents?
    var daysOfWeek: [WeekDay] = []
    var isActive: Bool
    
    private var blockManager: AppBlockManager
    private var activityName: DeviceActivityName
    private var schedule: DeviceActivitySchedule
    
    var time: String {
        let startFormatted = formatTime(from: startsAt)
        let endFormatted = formatTime(from: endsAt)
        return "\(startFormatted) - \(endFormatted)"
    }
    
    var appsBlocked: Int {
        return selection.applications.count
    }

    var categoriesBlocked: Int {
        return selection.categories.count
    }
    
    var webDomainsBlocked: Int {
        return selection.webDomains.count
    }
    
    init(
        name: String,
        selection: FamilyActivitySelection,
        blockingType: BlockType,
        isAllDay: Bool,
        startsAt: DateComponents,
        endsAt: DateComponents,
        daysOfWeek: [WeekDay] = []
    ) {
        self.name = name
        self.selection = selection
        self.blockingType = blockingType
        self.isAllDay = isAllDay
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.daysOfWeek = daysOfWeek
        self.isActive = false
        self.activityName = DeviceActivityName("block_\(UUID().uuidString)")
        
        let startComponents = DateComponents(hour: startsAt.hour ?? 0, minute: startsAt.minute ?? 0)
        let endComponents = DateComponents(hour: endsAt.hour ?? 23, minute: endsAt.minute ?? 59)
        self.schedule = DeviceActivitySchedule(intervalStart: startComponents, intervalEnd: endComponents, repeats: true)
        
        self.blockManager = AppBlockManager(
            selection: self.selection,
            activityName: self.activityName,
            schedule: self.schedule
        )
        
        createSchedule(
            for: daysOfWeek,
            startHour: self.startsAt?.hour ?? 0,
            startMinute: self.startsAt?.minute ?? 0,
            endHour: self.endsAt?.hour ?? 23,
            endMinute: self.endsAt?.minute ?? 59
        )
    }
    
    private func formatTime(from components: DateComponents?) -> String {
        guard let hour = components?.hour, let minute = components?.minute else {
            return "00:00"
        }
        return String(format: "%02d:%02d", hour, minute)
    }
    
    func createSchedule(
        for weekDays: [WeekDay],
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int
    ) {
        guard startHour >= 0, startHour < 24, endHour >= 0, endHour < 24,
              startMinute >= 0, startMinute < 60, endMinute >= 0, endMinute < 60 else {
            return
        }
        
        let scheduleEvents = weekDays.compactMap { day -> [DateComponents]? in
            var startComponents = DateComponents()
            startComponents.weekday = day.rawValue + 1
            startComponents.hour = startHour
            startComponents.minute = startMinute
            
            var endComponents = DateComponents()
            endComponents.weekday = day.rawValue + 1
            endComponents.hour = endHour
            endComponents.minute = endMinute
            
            return [startComponents, endComponents]
        }.flatMap { $0 }
        
        guard !scheduleEvents.isEmpty else {
            return
        }
        
        let startComponents = scheduleEvents[0]
        let endComponents = scheduleEvents[1]
        self.schedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: true
        )

        blockManager.updateSchedule(self.schedule)
    }
    
    // MARK: - Block Functions: BlockManager
    func activateBlock() {
        blockManager.startBlock()
    }

    func deactivateBlock() {
        blockManager.stopBlock()
    }
    
    func updateBlock() {
        blockManager.stopBlock()
        blockManager.startBlock()
    }
    
    // MARK: - Edit properties
    func updateSelection(_ selection: FamilyActivitySelection) {
        self.selection = selection
        blockManager.updateSelection(selection)
    }
    
    func updateDaysOfWeek(_ daysOfWeek: [WeekDay]) {
        self.daysOfWeek = daysOfWeek
        createSchedule(
            for: daysOfWeek,
            startHour: startsAt?.hour ?? 0,
            startMinute: startsAt?.minute ?? 0,
            endHour: endsAt?.hour ?? 23,
            endMinute: endsAt?.minute ?? 59
        )
    }

    func updateStartAndEndTime(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int) {
        // Atualiza os horários da sessão
        self.startsAt?.hour = startHour
        self.startsAt?.minute = startMinute
        self.endsAt?.hour = endHour
        self.endsAt?.minute = endMinute
        
        // Recria o schedule com os novos horários
        createSchedule(
            for: daysOfWeek,
            startHour: startHour,
            startMinute: startMinute,
            endHour: endHour,
            endMinute: endMinute
        )
    }

    func updateStartTime(startHour: Int, startMinute: Int) {
        updateStartAndEndTime(startHour: startHour, startMinute: startMinute, endHour: endsAt?.hour ?? 23, endMinute: endsAt?.minute ?? 59)
    }

    func updateEndTime(endHour: Int, endMinute: Int) {
        updateStartAndEndTime(startHour: startsAt?.hour ?? 0, startMinute: startsAt?.minute ?? 0, endHour: endHour, endMinute: endMinute)
    }
}


