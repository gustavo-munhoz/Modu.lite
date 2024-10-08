//
//  SettingsViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import Foundation
import UIKit

enum Setting {
    case subscription
    case tutorials
    case faq
    case help
}

struct SettingCellData {
    let setting: Setting
    let symbolName: String
    let symbolColor: UIColor
    let titleKey: SettingsLocalizedTexts
    
    static func subscription() -> Self {
        .init(
            setting: .subscription,
            symbolName: "star.circle",
            symbolColor: .lemonYellow,
            titleKey: .settingsViewSubscriptionDetailsTitle
        )
    }
    
    static func tutorials() -> Self {
        .init(
            setting: .tutorials,
            symbolName: "doc.questionmark",
            symbolColor: .fiestaGreen,
            titleKey: .settingsViewTutorialsTitle
        )
    }
    
    static func faq() -> Self {
        .init(
            setting: .faq,
            symbolName: "bubble.left.and.bubble.right",
            symbolColor: .carrotOrange,
            titleKey: .settingsViewFAQTitle
        )
    }
    
    static func help() -> Self {
        .init(
            setting: .help,
            symbolName: "questionmark.circle",
            symbolColor: .blueberry,
            titleKey: .settingsViewHelpTitle
        )
    }
}

class SettingsViewModel {
    // MARK: - Properties
    private let settingsData: [SettingCellData] = [
        .subscription(),
        .tutorials(),
        .faq(),
        .help()
    ]
    
    // MARK: - Getters
    
    func getSettingsCount() -> Int {
        settingsData.count
    }
    
    func getSettingData(at index: Int) -> SettingCellData? {
        guard index >= 0, index < settingsData.count else {
            return nil
        }
        
        return settingsData[index]
    }
}
