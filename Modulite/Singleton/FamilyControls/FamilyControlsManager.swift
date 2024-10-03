//
//  File.swift
//  Modulite
//
//  Created by André Wozniack on 02/10/24.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

class FamilyControlsManager: ObservableObject {
    static let shared = FamilyControlsManager()
    private let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()
    
    @Published var activitySelection = FamilyActivitySelection() {
        willSet {
            print("got here \(newValue)")
            
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
            
            print("applications \(applications)")
            print("categories \(categories)")
            
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(
                    categories
                )
            store.shield.webDomainCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(
                    categories
                )
        }
    }
    
    func requestAuthorization() {
        let authCenter = AuthorizationCenter.shared
        Task {
            do {
                try await authCenter.requestAuthorization(for: .individual)
            } catch {
                print("Authorization Error")
            }
        }
    }

    func initiateMonitoring(with selection: FamilyActivitySelection) {
        let applications = selection.applicationTokens
        let categories = selection.categoryTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(categories)
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(categories)
        
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true,
            warningTime: nil
        )
        
        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print("Could not start monitoring \(error)")
        }
    }
    
    func stopMonitoring() {
        center.stopMonitoring()
    }
    
    func encourageAll() {
        store.shield.applications = []
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific([])
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific([])
    }

    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    func initiateMonitoring() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true,
            warningTime: nil
        )
        
        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print("Could not start monitoring \(error)")
        }
        store.dateAndTime.requireAutomaticDateAndTime = true
        store.account.lockAccounts = true
        store.passcode.lockPasscode = true
        store.siri.denySiri = true
        store.appStore.denyInAppPurchases = true
        store.appStore.maximumRating = 200
        store.appStore.requirePasswordForPurchases = true
        store.media.denyExplicitContent = true
        store.gameCenter.denyMultiplayerGaming = true
        store.media.denyMusicService = false
    }

}

extension DeviceActivityName {
    static let daily = Self("daily")
}
