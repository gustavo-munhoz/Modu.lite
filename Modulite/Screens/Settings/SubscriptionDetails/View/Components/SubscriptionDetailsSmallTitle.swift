//
//  SubscriptionDetailsSmallTitle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/10/24.
//

import UIKit

class SubscriptionDetailsSmallTitle: UILabel {
    convenience init(localizedKey: SubscriptionLocalizedTexts) {
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
