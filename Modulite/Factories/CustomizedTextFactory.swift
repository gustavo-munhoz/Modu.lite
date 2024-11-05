//
//  CustomizedTextFactory.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/09/24.
//

import UIKit

class CustomizedTextFactory {
    
    static func createTextWithAsterisk(
        with text: String,
        asteriskRect: CGRect = CGRect(x: 0, y: -2.5, width: 21, height: 21),
        textStyle: UIFont.TextStyle = .title2,
        symbolicTraits: UIFontDescriptor.SymbolicTraits = .traitBold.union(.traitItalic),
        paragraphHeadIndent: CGFloat = 28
    ) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        let image = UIImage(systemName: "asterisk")?
            .withTintColor(.lemonYellow, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(weight: .heavy))
                
        imageAttachment.image = image
        imageAttachment.bounds = asteriskRect
                
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString()
                
        completeText.append(attachmentString)
        completeText.append(NSAttributedString(string: "  "))
                
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = paragraphHeadIndent
        paragraphStyle.firstLineHeadIndent = 0
                
        completeText.addAttributes(
            [.font: UIFont(textStyle: textStyle, weight: .heavy)],
            range: NSRange(location: 0, length: 1)
        )
                
        let titleString = NSAttributedString(string: text, attributes: [
            .font: UIFont(textStyle: textStyle, symbolicTraits: symbolicTraits)!,
            .paragraphStyle: paragraphStyle
        ])
                
        completeText.append(titleString)
                
        completeText.addAttributes(
            [.paragraphStyle: paragraphStyle],
            range: NSRange(location: 0, length: completeText.length)
        )
        
        return completeText
    }
    
    static func createMarkdownTextWithAsterisk(
        with markdownText: String,
        asteriskRect: CGRect = CGRect(x: 0, y: -2.5, width: 17, height: 17),
        paragraphHeadIndent: CGFloat = 0,
        textStyle: UIFont.TextStyle = .body
    ) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        
        let boldAsteriskImage = UIImage(systemName: "asterisk")?
            .withTintColor(.lemonYellow, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(weight: .heavy))
        
        imageAttachment.image = boldAsteriskImage
        imageAttachment.bounds = asteriskRect
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        let completeText = NSMutableAttributedString()
        completeText.append(attachmentString)
        completeText.append(NSAttributedString("  "))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = paragraphHeadIndent
        paragraphStyle.firstLineHeadIndent = 0

        if let markdownAttributedString = try? AttributedString(markdown: markdownText) {
            let attributedMarkdown = NSMutableAttributedString(markdownAttributedString)
                        
            attributedMarkdown.addAttributes([
                .paragraphStyle: paragraphStyle
            ], range: NSRange(location: 0, length: attributedMarkdown.length))
            
            completeText.append(attributedMarkdown)
        } else {
            let plainText = NSAttributedString(string: markdownText, attributes: [
                .paragraphStyle: paragraphStyle
            ])
            completeText.append(plainText)
        }
        
        completeText.addAttributes([
            .font: UIFont.preferredFont(forTextStyle: .body)
        ], range: .init(location: 0, length: completeText.length))

        return completeText
    }
    
    static func createFromMarkdown(
        with markdownText: String,
        paragraphHeadIndent: CGFloat = 0,
        textStyle: UIFont.TextStyle = .body,
        font: UIFont? = nil,
        fontSize: CGFloat? = nil,
        alignment: NSTextAlignment = .natural
    ) -> NSAttributedString {
        let completeText = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = paragraphHeadIndent
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.alignment = alignment

        if let markdownAttributedString = try? AttributedString(markdown: markdownText) {
            let attributedMarkdown = NSMutableAttributedString(markdownAttributedString)
                        
            attributedMarkdown.addAttributes([
                .paragraphStyle: paragraphStyle
            ], range: NSRange(location: 0, length: attributedMarkdown.length))
            
            completeText.append(attributedMarkdown)
        } else {
            let plainText = NSAttributedString(string: markdownText, attributes: [
                .paragraphStyle: paragraphStyle
            ])
            completeText.append(plainText)
        }
        
        let selectedFont: UIFont
        if let font = font {
            selectedFont = fontSize != nil ? font.withSize(fontSize!) : font
        } else {
            selectedFont = fontSize != nil ? UIFont.systemFont(
                ofSize: fontSize!
            ) : UIFont.preferredFont(forTextStyle: textStyle)
        }
        
        completeText.addAttributes([
            .font: selectedFont
        ], range: .init(location: 0, length: completeText.length))

        return completeText
    }

}
