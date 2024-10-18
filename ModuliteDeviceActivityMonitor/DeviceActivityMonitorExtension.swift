//
//  DeviceActivityMonitorExtension.swift
//  ModuliteDeviceActivityMonitor
//
//  Created by André Wozniack on 26/09/24.
//

import DeviceActivity
import UserNotifications
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    func showLocalNotification(
        activityName: DeviceActivityName,
        title: String,
        desc: String
    ) {
        let model = AppBlockManager(activityName: activityName)
        let countSelectedAppToken =  model.countSelectedApp()
        let countSelectedCategoryToken =  model.countSelectedAppCategory()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Selected app: "+String(countSelectedAppToken)+" category: "+String(countSelectedCategoryToken)
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to show notification: \(error.localizedDescription)")
            }
        }
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Failed to add notification: \(error)")
            } else {
                print("Success add notification")
            }
        }
    }
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        let model = AppBlockManager(activityName: activity)
        model.startBlock()
        showLocalNotification(
            activityName: activity,
            title: "My Start Restrict App",
            desc: "Restriction App started successfully"
        )
        
        let socialStore = ManagedSettingsStore(named: ManagedSettingsStore.Name(activity.rawValue))
        socialStore.clearAllSettings()
        model.startBlock()
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        let model = AppBlockManager(activityName: activity)
        model.stopAppRestrictions()
        showLocalNotification(
            activityName: activity,
            title: "My Restriction Stopped",
            desc: "Restriction App is stopped"
        )
    }
}
