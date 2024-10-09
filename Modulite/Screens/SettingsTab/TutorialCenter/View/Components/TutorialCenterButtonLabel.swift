//
//  TutorialCenterButtonLabel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialCenterButtonLabel: UILabel {
    convenience init(textLocalizedKey: TutorialCenterLocalizedTexts) {
        self.init(frame: .zero)
        
        text = .localized(for: textLocalizedKey)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont(textStyle: .body, weight: .semibold)
        textColor = .textPrimary
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        adjustsFontSizeToFitWidth = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
