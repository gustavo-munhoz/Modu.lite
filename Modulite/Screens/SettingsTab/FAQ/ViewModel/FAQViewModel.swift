//
//  FAQViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import Foundation

struct FAQQuestionModel {
    let question: String
    let answer: String
    
    init(questionKey: FAQLocalizedTexts, answerKey: FAQLocalizedTexts) {
        question = .localized(for: questionKey)
        answer = .localized(for: answerKey)
    }
}

class FAQViewModel {
    private(set) var questions: [FAQQuestionModel] = [
        .init(questionKey: .faqViewSectionHowModuliteWorkTitle, answerKey: .faqViewSectionHowModuliteWorkText),
        .init(questionKey: .faqViewSectionCreateAccountTitle, answerKey: .faqViewSectionCreateAccountText),
        .init(questionKey: .faqViewSectionSkinsPurchasesTitle, answerKey: .faqViewSectionSkinsPurchasesText),
        .init(questionKey: .faqViewSectionWhyOpensFirstTitle, answerKey: .faqViewSectionWhyOpensFirstText),
        .init(questionKey: .faqViewSectionPersonalDataTitle, answerKey: .faqViewSectionPersonalDataText),
        .init(questionKey: .faqViewSectionAccessOverAppsTitle, answerKey: .faqViewSectionAccessOverAppsText),
        .init(questionKey: .faqViewSectionChangePermanentlyTitle, answerKey: .faqViewSectionChangePermanentlyText),
        .init(questionKey: .faqViewSectionHavingProblemsTitle, answerKey: .faqViewSectionHavingProblemsText)
    ]
}
