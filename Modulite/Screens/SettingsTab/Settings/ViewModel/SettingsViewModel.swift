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
    case termsOfUse
    case privacyPolicy
}

enum SettingUrl: String {
    // swiftlint:disable:next line_length
    case termsOfUse = "https://perfect-daisy-6f1.notion.site/Modu-lite-s-Terms-of-Use-11abd895db1c8041b097eb2f6aeadb54?pvs=74"
    // swiftlint:disable:next line_length
    case privacyPolicy = "https://perfect-daisy-6f1.notion.site/Modu-lite-s-Privacy-Policy-11abd895db1c80d78fd6ddffabbf1e0b?pvs=4"
}

struct SettingCellData {
    let setting: Setting
    let symbolName: String
    let symbolColor: UIColor
    let titleKey: SettingsLocalizedTexts
    
    static func subscription() -> Self {
        .init(
            setting: .subscription,
            symbolName: "custom.diamond",
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
    
    static func termsOfUse() -> Self {
        .init(
            setting: .termsOfUse,
            symbolName: "text.document",
            symbolColor: .burntEnds,
            titleKey: .settingsViewTermsOfUseTitle
        )
    }
    
    static func privacyPolicy() -> Self {
        .init(
            setting: .privacyPolicy,
            symbolName: "lock.document",
            symbolColor: .burntCoconut,
            titleKey: .settingsViewPrivacyPolicyTitle
        )
    }
}

class SettingsViewModel {
    // MARK: - Properties
    private let settingsData: [SettingCellData] = [
        .subscription(),
        .tutorials(),
        .faq(),
        .help(),
        .termsOfUse(),
        .privacyPolicy()
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
    
    func getTermsOfUseURL() -> URL {
        guard let url = URL(
            string: SettingUrl.termsOfUse.rawValue
        ) else { fatalError("Unable to create URL") }
        
        return url
    }
    
    func getPrivacyPolicyURL() -> URL {
        guard let url = URL(
            string: SettingUrl.privacyPolicy.rawValue
        ) else { fatalError("Unable to create URL") }
        
        return url
    }
}
