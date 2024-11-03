//
//  EditModuleTip.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import SwiftUI
import TipKit

struct EditModuleTip: Tip {
    var title: Text {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingEditModulesTitle)
        )
    }
    
    var rules: [Rule] {
        #Rule(WidgetEditorViewController.didDragModule) {
            $0.donations.count > 0
        }
    }
}
