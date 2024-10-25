//
//  AppDeviceActivity.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 15/10/24.
//

import Foundation
import ManagedSettings

struct AppDeviceActivity: Identifiable, Hashable {
    var id: String
    var token: ApplicationToken?
    var displayName: String
    var duration: TimeInterval
    var numberOfPickups: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AppDeviceActivity, rhs: AppDeviceActivity) -> Bool {
        return lhs.id == rhs.id
    }
}
