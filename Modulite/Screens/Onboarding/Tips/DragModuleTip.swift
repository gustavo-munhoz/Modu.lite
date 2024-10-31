//
//  DragModuleTip.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import SwiftUI
import TipKit

struct DragModuleTip: Tip {
    var title: Text {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingDragModulesTitle)
        )
    }
}
