//
//  OnboardingPreferences.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

enum Onboarding: String, UserPreferenceKey {
    var key: String {
        self.rawValue
    }
    
    case hasCompletedOnboarding
}
