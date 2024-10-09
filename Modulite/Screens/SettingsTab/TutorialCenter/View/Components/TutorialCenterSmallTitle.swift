//
//  TutorialCenterSmallTitle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

class TutorialCenterSmallTitle: UILabel {
    convenience init(localizedKey: TutorialCenterLocalizedTexts) {
        self.init(frame: .zero)
        
        text = .localized(for: localizedKey)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont(textStyle: .caption1, weight: .semibold)
        textColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
