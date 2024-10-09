//
//  TutorialStepsStackView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialStepsStackView: UIStackView {
        
    init(localizedKeys: [TutorialWidgetConfigurationTexts]) {
        super.init(frame: .zero)
        setupView(localizedKeys: localizedKeys)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupView(localizedKeys: [TutorialWidgetConfigurationTexts]) {
        axis = .vertical
        spacing = 4
        distribution = .equalSpacing
                
        for key in localizedKeys {
            let label = TutorialTextParagraphLabel(textLocalizedKey: key)
            addArrangedSubview(label)
        }
    }
}
