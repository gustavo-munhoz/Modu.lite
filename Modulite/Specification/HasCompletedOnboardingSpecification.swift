//
//  HasCompletedOnboardingSpecification.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 28/11/24.
//

import Foundation

struct HasCompletedOnboardingSpecification: Specification {
    func isSatisfied() -> Bool {
        UserPreference<Onboarding>.shared.bool(for: .hasCompletedOnboarding)
    }
}
