//
//  TutorialMultiParagraphLabel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit

class TutorialMultiParagraphLabel: UIStackView {
    convenience init(localizedKeys: [TutorialEditWidgetLocalizedTexts]) {
        var paragraphs: [TutorialTextParagraphLabel] = []
        
        for key in localizedKeys {
            let paragraph = TutorialTextParagraphLabel(textLocalizedKey: key)
            paragraphs.append(paragraph)
        }
        
        self.init(arrangedSubviews: paragraphs)
        
        axis = .vertical
        spacing = 20
        distribution = .equalSpacing
    }
}
