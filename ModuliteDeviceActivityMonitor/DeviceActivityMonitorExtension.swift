//
//  DeviceActivityMonitorExtension.swift
//  ModuliteDeviceActivityMonitor
//
//  Created by André Wozniack on 26/09/24.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()


    // You can use the `store` property to shield apps when an interval starts, ends, or meets a threshold.
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
//        
//
//        let model = AppBlockManager()
//        let applications = model.selectionToShield.applications
//        store.shield.applications = applications.isEmpty ? nil : applications
     }
}
