//
//  BlockMangaer.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import Foundation
import ManagedSettings
import DeviceActivity
import FamilyControls

class BlockManager {
    
    private let store: ManagedSettingsStore
    private let center = DeviceActivityCenter()
    private var activityName: DeviceActivityName
    private var activitySelection: FamilyActivitySelection {
        return getSavedFamilyActivitySelection() ?? FamilyActivitySelection()
    }
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    private var userDefaultsKey: String {
        return self.activityName.rawValue
    }
    
    init(activityName: DeviceActivityName) {

        self.activityName = activityName
        self.store = ManagedSettingsStore(
            named: ManagedSettingsStore.Name(
                rawValue: activityName.rawValue
            )
        )

    }
    
    func startBlock() {
        guard let activitySelection = getSavedFamilyActivitySelection() else {
            print("Nenhuma seleção de atividade foi salva. Não é possível iniciar o monitoramento.")
            return
        }
        
        store.shield.applications = activitySelection
            .applicationTokens
            .isEmpty ? nil : activitySelection.applicationTokens
        
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(activitySelection.categoryTokens)
        
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(activitySelection.categoryTokens)
    }
    
    func stopBlock() {
        store.clearAllSettings()
        print("Monitoramento parado para \(activityName.rawValue)")
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
}
