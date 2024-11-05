//
//  SelectWidgetStyleTip.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import SwiftUI
import TipKit

struct SelectWidgetStyleTip: Tip {
    var title: Text {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingSelectWidgetStyleTitle)
        )
    }
    
    var message: Text? {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingSelectWidgetStyleMessage)
        )
    }
    
    var rules: [Rule] {
        #Rule(WidgetSetupViewController.didSelectWidgetStyle) {
            $0.donations.count == 0
        }
    }
}
