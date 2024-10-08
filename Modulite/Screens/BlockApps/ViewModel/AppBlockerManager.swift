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
        store.shield.applications = nil
        store.shield.webDomains = nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil

        center.stopMonitoring([activityName])
        print("Monitoramento parado para \(activityName.rawValue)")
    }
}
