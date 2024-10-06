//
//  TutorialTitleLabel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/10/24.
//

import UIKit

class TutorialTitleLabel: UILabel {
    convenience init(textLocalizedKey: TutorialWidgetConfigurationTexts) {
        self.init(frame: .zero)
        
        text = .localized(for: textLocalizedKey)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont(textStyle: .title2, weight: .bold)
        textAlignment = .left
        lineBreakMode = .byWordWrapping
        numberOfLines = -1
        textColor = .textPrimary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
