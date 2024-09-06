//
//  CustomizedTextFactory.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/09/24.
//

import UIKit

class CustomizedTextFactory {
    
    static func createTextWithAsterisk(with text: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment(
            image: UIImage(systemName: "asterisk")!
                .withTintColor(.lemonYellow, renderingMode: .alwaysOriginal)
        )
        
        imageAttachment.bounds = CGRect(x: 0, y: -2.5, width: 21, height: 21)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString("")
        
        completeText.append(attachmentString)
        completeText.append(NSAttributedString("  "))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 28
        paragraphStyle.firstLineHeadIndent = 0
        
        completeText.addAttributes(
            [.font: UIFont(textStyle: .title2, weight: .heavy)],
            range: NSRange(location: 0, length: 1)
        )
        
        let titleString = NSAttributedString(string: text, attributes: [
            .font: UIFont(textStyle: .title2, symbolicTraits: .traitBold.union(.traitItalic))!,
            .paragraphStyle: paragraphStyle
        ])
        
        completeText.append(titleString)
        completeText.addAttributes(
            [.paragraphStyle: paragraphStyle],
            range: NSRange(location: 0, length: completeText.length)
        )
        
        return completeText
    }
    
}
