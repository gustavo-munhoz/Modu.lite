//
//  TutorialLargeTitleLabel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialLargeTitleLabel: UILabel {
    convenience init(textLocalizedKey: TutorialCenterLocalizedTexts) {
        self.init(frame: .zero)
        
        text = .localized(for: textLocalizedKey)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont(textStyle: .title1, weight: .bold)
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
