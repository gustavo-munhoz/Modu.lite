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
        
        let text = String.localized(for: textLocalizedKey)
        let font = UIFont(textStyle: .title2, weight: .bold)
                
        let firstThreeCharacters = String(text.prefix(3))
        let sizeOfFirstThreeCharacters = (firstThreeCharacters as NSString)
            .size(withAttributes: [.font: font])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.headIndent = sizeOfFirstThreeCharacters.width
        paragraphStyle.firstLineHeadIndent = 0
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: font,
                .foregroundColor: UIColor.textPrimary
            ]
        )
        
        self.attributedText = attributedText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        numberOfLines = 0
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
