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
    private let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()
    
    @Published var activitySelection: FamilyActivitySelection
    private var activityName: DeviceActivityName
    private var schedule: DeviceActivitySchedule

    init(selection: FamilyActivitySelection, activityName: DeviceActivityName, schedule: DeviceActivitySchedule) {
        self.activitySelection = selection
        self.activityName = activityName
        self.schedule = schedule
    }
    
    func startBlock() {
        let applications = activitySelection.applicationTokens
        let categories = activitySelection.categoryTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(categories)
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(categories)
        
        do {
            try center.startMonitoring(activityName, during: schedule)
            print("Monitoramento iniciado com sucesso para \(activityName.rawValue)")
        } catch {
            print("Erro ao iniciar monitoramento: \(error)")
        }
    }
    
     func stopBlock() {
         let applicationsToRemove = activitySelection.applicationTokens
         
         var currentApplications = store.shield.applications ?? Set<ApplicationToken>()
         currentApplications.subtract(applicationsToRemove)

         store.shield.applications = currentApplications.isEmpty ? nil : currentApplications

         let categoriesToRemove = activitySelection.categoryTokens
         var currentCategories = ShieldSettings.ActivityCategoryPolicy<Application>.specific(categoriesToRemove)

         store.shield.applicationCategories = categoriesToRemove.isEmpty ? nil : .specific(categoriesToRemove)

         store.shield.webDomainCategories = nil
         center.stopMonitoring([activityName])
         print("Monitoramento parado para \(activityName.rawValue)")
     }
}
