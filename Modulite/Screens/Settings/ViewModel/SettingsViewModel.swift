//
//  SettingsViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import Foundation
import UIKit

struct PreferenceCellData {
    let symbolName: String
    let symbolColor: UIColor
    let titleKey: SettingsLocalizedTexts
    
    static func subscription() -> Self {
        .init(
            symbolName: "star.circle",
            symbolColor: .lemonYellow,
            titleKey: .settingsViewSubscriptionDetailsTitle
        )
    }
    
    static func tutorials() -> Self {
        .init(
            symbolName: "doc.questionmark",
            symbolColor: .fiestaGreen,
            titleKey: .settingsViewTutorialsTitle
        )
    }
    
    static func faq() -> Self {
        .init(
            symbolName: "bubble.left.and.bubble.right",
            symbolColor: .carrotOrange,
            titleKey: .settingsViewFAQTitle
        )
    }
    
    static func help() -> Self {
        .init(
            symbolName: "questionmark.circle",
            symbolColor: .blueberry,
            titleKey: .settingsViewHelpTitle
        )
    }
}

class SettingsViewModel {
    
    let preferenceCells: [PreferenceCellData] = [
        .subscription(),
        .tutorials(),
        .faq(),
        .help()
    ]
}
