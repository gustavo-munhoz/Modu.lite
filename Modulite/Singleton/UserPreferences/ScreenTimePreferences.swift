//
//  ScreenTimePreferences.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 18/10/24.
//

enum ScreenTime: String, UserPreferenceKey {
    var key: String {
        self.rawValue
    }
    
    case hasSetPreferenceBefore
}
