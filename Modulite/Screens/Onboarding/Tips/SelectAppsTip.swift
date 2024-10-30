//
//  SelectAppsTip.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import SwiftUI
import TipKit

struct SelectAppsTip: Tip {
    var title: Text {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingSelectAppsTitle)
        )
    }
    
    var message: Text? {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingSelectAppsMessage)
        )
    }
    
    var rules: [Rule] {
        #Rule(WidgetSetupViewController.didSelectWidgetStyle) {
            $0.donations.count > 0
        }
    }
}
