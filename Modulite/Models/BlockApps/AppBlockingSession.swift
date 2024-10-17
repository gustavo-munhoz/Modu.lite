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
        
        self.schedule = DeviceActivitySchedule(
            intervalStart: startsAt,
            intervalEnd: endsAt,
            repeats: true
        )
        
        self.blockManager = AppBlockManager(
            selection: selection,
            activityName: self.activityName,
            schedule: self.schedule
        )
    }
    
    private func formatTime(from components: DateComponents?) -> String {
        guard let hour = components?.hour, let minute = components?.minute else {
            return "00:00"
        }
        return String(format: "%02d:%02d", hour, minute)
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
    func updateSelection(_ selection: FamilyActivitySelection ) {
        blockManager.activitySelection = selection
    }
}


extension AppBlockingSession {
    func shouldActivateBlock() -> Bool {
        // Obter a data e hora atual
        let now = Date()
        let calendar = Calendar.current
        
        // Verificar o dia da semana atual
        let currentWeekday = calendar.component(.weekday, from: now) - 1 // Calendar's weekday starts from 1 (Sunday)
        guard daysOfWeek.contains(WeekDay(rawValue: currentWeekday) ?? .monday) else {
            return false
        }
        
        // Obter os componentes de tempo atuais
        let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: now)
        guard let currentHour = currentTimeComponents.hour, let currentMinute = currentTimeComponents.minute else {
            return false
        }

        // Verificar se está dentro do intervalo de tempo
        if let allDay = isAllDay {
            return true
        }
        
        // Comparar com o horário de início e término
        if let startHour = startsAt?.hour, let startMinute = startsAt?.minute,
           let endHour = endsAt?.hour, let endMinute = endsAt?.minute {
            
            let currentTimeInMinutes = (currentHour * 60) + currentMinute
            let startTimeInMinutes = (startHour * 60) + startMinute
            let endTimeInMinutes = (endHour * 60) + endMinute
            
            // Se o tempo atual está dentro do intervalo configurado, ativar
            return currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes <= endTimeInMinutes
        }
        
        return false
    }
}
