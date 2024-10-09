//
//  HelpViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import Foundation

struct HelpTopicModel {
    let title: String
    let text: String
    
    init(titleKey: HelpLocalizedTexts, textKey: HelpLocalizedTexts) {
        title = .localized(for: titleKey)
        text = .localized(for: textKey)
    }
}

class HelpViewModel {
    
    private(set) var helpTopics: [HelpTopicModel] = [
        .init(
            titleKey: .helpViewProblemSettingUpWidgetTitle,
            textKey: .helpViewProblemSettingUpWidgetText
        ),
        .init(
            titleKey: .helpViewProblemWithPurchasesTitle,
            textKey: .helpViewProblemWithPurchasesText
        ),
        .init(
            titleKey: .helpViewCancelSubscriptionTitle,
            textKey: .helpViewCancelSubscriptionText
        ),
        .init(
            titleKey: .helpViewEncounteredBugTitle,
            textKey: .helpViewEncounteredBugText1
        )
    ]
}
