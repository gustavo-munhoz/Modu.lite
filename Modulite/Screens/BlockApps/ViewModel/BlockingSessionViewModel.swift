//
//  CreateSessionViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 03/10/24.
//

import Foundation
import FamilyControls

class BlockingSessionViewModel: ObservableObject {
    // MARK: - Properties
    @Published var activitySelection: FamilyActivitySelection = .init()
    var name: String = ""
    var blockingType: BlockType = .scheduled
    var isAllDay: Bool = false
    var startsAt: DateComponents = .init(hour: 0, minute: 0)
    var endsAt: DateComponents = .init(hour: 23, minute: 59)
    var daysOfWeek: [WeekDay] = []
    var isActive = true
    
    // MARK: - Setters
    
    func setName(_ newName: String) {
        name = newName
    }
    
    func setBlockingType(_ newBlockingType: BlockType) {
        blockingType = newBlockingType
    }
    
    func setIsAllDay(_ newIsAllDay: Bool) {
        isAllDay = newIsAllDay
    }
    
    func setStartsAt(_ newStartsAt: DateComponents) {
        startsAt = newStartsAt
    }
    
    func setEndsAt(_ newEndsAt: DateComponents) {
        endsAt = newEndsAt
    }
    
    func setDaysOfWeek(_ newDaysOfWeek: [WeekDay]) {
        daysOfWeek = newDaysOfWeek
    }
    
    func appendDayOfWeek(_ newDay: WeekDay) {
        daysOfWeek.append(newDay)
    }
    
    func removeDayOfWeek(_ day: WeekDay) {
        daysOfWeek.removeAll(where: { $0 == day })
    }
    
    func setIsActive(_ newIsActive: Bool) {
        isActive = newIsActive
    }
    
    func setActivitySelection(_ selection: FamilyActivitySelection) {
        activitySelection = selection
    }
    
    func loadSession(_ session: AppBlockingSession) {
        self.name = session.name ?? ""
        self.activitySelection = session.selection
        self.blockingType = session.blockingType ?? .scheduled
        self.isAllDay = session.isAllDay ?? false
        self.startsAt = session.startsAt ?? DateComponents(hour: 0, minute: 0)
        self.endsAt = session.endsAt ?? DateComponents(hour: 23, minute: 59)
        self.daysOfWeek = session.daysOfWeek
        self.isActive = session.isActive
    }

}
