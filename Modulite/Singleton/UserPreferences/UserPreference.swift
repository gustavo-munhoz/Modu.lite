//
//  UserPreference.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 18/10/24.
//

import Foundation

protocol UserPreferenceKey {
    var key: String { get }
}

class UserPreferenceManager {
    private static var instances: [ObjectIdentifier: Any] = [:]
        
    static func sharedInstance<T: UserPreferenceKey>(for type: T.Type) -> UserPreference<T> {
        let key = ObjectIdentifier(type)
        if let instance = instances[key] as? UserPreference<T> {
            return instance
        } else {
            let instance = UserPreference<T>()
            instances[key] = instance
            return instance
        }
    }
}

class UserPreference<T: UserPreferenceKey> {
    static var shared: UserPreference<T> {
        return UserPreferenceManager.sharedInstance(for: T.self)
    }
        
    fileprivate init() {}
    
    func set(_ value: any Hashable, for preference: T) {
        UserDefaults.standard.set(value, forKey: preference.key)
    }
    
    func get(for preference: T) -> Any? {
        UserDefaults.standard.value(forKey: preference.key)
    }
    
    func bool(for preference: T) -> Bool {
        UserDefaults.standard.bool(forKey: preference.key)
    }
}
