//
//  AppBlockerManager.swift
//  Modulite
//
//  Created by André Wozniack on 03/10/24.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

class AppBlockManager: ObservableObject {
    
    @Published var activitySelection: FamilyActivitySelection = .init()
    private let store: ManagedSettingsStore
    private let center = DeviceActivityCenter()
    
    private var activityName: DeviceActivityName
    
    private let encoder = PropertyListEncoder()

    // Used to decode codable from UserDefaults
    private let decoder = PropertyListDecoder()

    private let userDefaultsKey: String
    
    init(activityName: DeviceActivityName) {
        self.activityName = activityName
        self.store = ManagedSettingsStore(named: ManagedSettingsStore.Name(activityName.rawValue))
        self.userDefaultsKey = activityName.rawValue
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
    
    func startBlock() {
        print("Start App Restriction")
        
        // Pull the selection out of the app's model and configure the application shield restriction accordingly
//        let applications = MyModel.shared.familyActivitySelection
        guard let applications = getSavedFamilyActivitySelection() else {
            return
        }
        
        if applications.applicationTokens.isEmpty {
            print("application not selected")
        }
        
        if applications.applicationTokens.isEmpty {
            print("empty applicationTokens")
        }

        if applications.categoryTokens.isEmpty {
            print("empty categoryTokens")
        }
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications
            .categoryTokens
            .isEmpty ? nil : ShieldSettings
            .ActivityCategoryPolicy
            .specific(applications.categoryTokens)
        
        store.media.denyExplicitContent = true
        
        store.application.denyAppRemoval = true
        
        store.dateAndTime.requireAutomaticDateAndTime = true
        store.application.blockedApplications = applications.applications
        
    }
    
    func stopAppRestrictions() {
        print("Stop App Restriction")
        store.clearAllSettings()
    }
    
    func isAppLocked() -> Bool {
        let isShieldEmpty = (store.shield.applicationCategories == nil)
        return !isShieldEmpty
    }
    
    func countSelectedAppCategory() -> Int {
        let applications = getSavedFamilyActivitySelection()
        
        if applications == nil {
            print("application not selected")
            return 0
        }
        return applications!.categoryTokens.count
    }
    
    // count selected category
    func countSelectedApp() -> Int {
        let applications = getSavedFamilyActivitySelection()
        if applications == nil {
            print("category not selected")
            return 0
        }
        return applications!.applicationTokens.count
    }
    
    func schedulingRestrictions(scheduleInSecond: Double) {
        
        print("Start monitor restriction, by", scheduleInSecond, "seconds")
        let startSchedulingTime = Date()
        let endSchedulingTime = Calendar.current.date(
            byAdding: .second,
            value: Int(scheduleInSecond),
            to: startSchedulingTime
        )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print(
            "Scheduling monitor started on ",
            dateFormatter.string(from: startSchedulingTime)
        )
        print(
            "Scheduling monitor will end on ",
            dateFormatter.string(from: endSchedulingTime ?? Date())
        )
        let schedule = DeviceActivitySchedule(
            intervalStart: Calendar.current.dateComponents(
                [
                    .hour,
                    .minute
                ],
                from: startSchedulingTime
            ),
            intervalEnd: Calendar.current.dateComponents(
                [
                    .hour,
                    .minute
                ],
                from: endSchedulingTime ?? startSchedulingTime
            ),
            repeats: true,
            warningTime: nil
        )

        let center = DeviceActivityCenter()
        
        do {
            try center.startMonitoring(activityName, during: schedule)
            print("Success Scheduling Monitor Activity")
        } catch {
            print("Error Scheduling Monitor Activity: \(error.localizedDescription)")
        }
    }
    
    func createSchedule(
        for weekDays: [WeekDay],
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int
    ) -> DeviceActivitySchedule? {
        guard startHour >= 0, startHour < 24, endHour >= 0, endHour < 24,
              startMinute >= 0, startMinute < 60, endMinute >= 0, endMinute < 60 else {
            return nil
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
            return nil
        }
        
        let startComponents = scheduleEvents[0]
        let endComponents = scheduleEvents[1]
        
        return DeviceActivitySchedule(intervalStart: startComponents, intervalEnd: endComponents, repeats: true)
    }

}
