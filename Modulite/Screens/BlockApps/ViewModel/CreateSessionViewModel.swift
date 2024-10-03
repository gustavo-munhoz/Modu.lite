//
//  CreateSessionViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 03/10/24.
//

import Foundation
import FamilyControls

class CreateSessionViewModel: ObservableObject {
    // MARK: - Properties
    @Published var activitySelection: FamilyActivitySelection = .init()
    private var name: String = ""
    private var blockingType: BlockType = .scheduled
    private var isAllDay: Bool = false
    private var startsAt: DateComponents = .init(hour: 0, minute: 0)
    private var endsAt: DateComponents = .init(hour: 23, minute: 59)
    private var daysOfWeek: [WeekDay] = []
    private var isActive = true // Já é criada iniciada
    
    // MARK: - Getters
    
    func getName() -> String {
        return name
    }
    
    func getBlockingType() -> BlockType {
        return blockingType
    }
    
    func getIsAllDay() -> Bool {
        return isAllDay
    }
    
    func getStartsAt() -> DateComponents {
        return startsAt
    }
    
    func getEndsAt() -> DateComponents {
        return endsAt
    }
    
    func getDaysOfWeek() -> [WeekDay] {
        return daysOfWeek
    }
    
    func getIsActive() -> Bool {
        return isActive
    }
    
    func getActivitySelection() -> FamilyActivitySelection {
        return activitySelection
    }
    
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
    
    func setIsActive(_ newIsActive: Bool) {
        isActive = newIsActive
    }
    
    func setActivitySelection(_ selection: FamilyActivitySelection) {
        activitySelection = selection
    }
}

