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
    
    // Used to encode codable to UserDefaults
    private let encoder = PropertyListEncoder()

    // Used to decode codable from UserDefaults
    private let decoder = PropertyListDecoder()

    private let userDefaultsKey: String
    
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
            activityName: self.activityName
        )
        
        self.userDefaultsKey = activityName.rawValue
        
        saveFamilyActivitySelection(selection: selection)
    }
    
    private func formatTime(from components: DateComponents?) -> String {
        guard let hour = components?.hour, let minute = components?.minute else {
            return "00:00"
        }
        return String(format: "%02d:%02d", hour, minute)
    }
    
    func saveFamilyActivitySelection(selection: FamilyActivitySelection) {
        print(
            "selected app updated: ",
            selection.applicationTokens.count,
            " category: ",
            selection.categoryTokens.count
        )
        let defaults = UserDefaults.standard

        defaults.set(
            try? encoder.encode(selection),
            forKey: userDefaultsKey
        )
        
        print(getSavedFamilyActivitySelection()?.applications.count ?? "")
        print(getSavedFamilyActivitySelection()?.categories.count ?? "")
    }
    
    func getSavedFamilyActivitySelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: userDefaultsKey) else {
            return nil
        }
        var selectedApp: FamilyActivitySelection?
        let decoder = PropertyListDecoder()
        selectedApp = try? decoder.decode(FamilyActivitySelection.self, from: data)
        
        print("saved selected app updated: ", selectedApp?.categoryTokens.count ?? "0")
        return selectedApp
    }
    
    // MARK: - Block Functions: BlockManager
    func activateBlock() {
        blockManager.startBlock()
    }

    func deactivateBlock() {
        blockManager.stopAppRestrictions()
    }
    
    func updateBlock() {
        blockManager.stopAppRestrictions()
        blockManager.startBlock()
    }
    
    // MARK: - Edit properties
    func updateSelection(_ selection: FamilyActivitySelection ) {
        self.selection = selection
    }
}
