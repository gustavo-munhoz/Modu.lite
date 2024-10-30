//
//  ProceedToEditorTip.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import SwiftUI
import TipKit

struct ProceedToEditorTip: Tip {
    var title: Text {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingProceedToEditorTitle)
        )
    }
    
    var rules: [Rule] {
        #Rule(WidgetSetupViewController.didSelectApps) {
            $0.donations.count > 0
        }
    }
}
