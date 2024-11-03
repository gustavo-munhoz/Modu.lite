//
//  ButtonFactory.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 01/11/24.
//

import UIKit
import SnapKit

enum ButtonFactory {
    static func smallButton(
        titleKey: LocalizedKeyProtocol? = nil,
        font: UIFont = UIFont(textStyle: .title3, weight: .bold),
        image: UIImage? = nil,
        imagePadding: CGFloat = 10,
        imagePlacement: NSDirectionalRectEdge = .trailing,
        imagePointSize: CGFloat = 20,
        foregroundColor: UIColor = .white,
        backgroundColor: UIColor = .blueberry,
        contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center,
        size: CGSize = CGSize(width: 130, height: 45)
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        
        if let titleKey {
            let attributedTitle = AttributedString(
                .localized(for: titleKey),
                attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: foregroundColor
                ])
            )
            
            config.attributedTitle = attributedTitle
        }

        let image = image?
            .withTintColor(foregroundColor, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(pointSize: imagePointSize, weight: .semibold)
            )
        
        config.image = image
        config.imagePadding = imagePadding
        config.imagePlacement = imagePlacement
        config.baseForegroundColor = foregroundColor
        config.baseBackgroundColor = backgroundColor
        let view = UIButton(configuration: config)
        
        view.snp.makeConstraints { make in
            make.width.height.equalTo(size)
        }
        
        view.configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                switch button.state {
                case .highlighted:
                    button.transform = .init(scaleX: 0.97, y: 0.97)
                default:
                    button.transform = .identity
                }
            }
        }
        
        view.contentHorizontalAlignment = contentHorizontalAlignment
        
        return view
    }
    
    static func mediumButton(
        titleKey: LocalizedKeyProtocol? = nil,
        font: UIFont = UIFont(textStyle: .title3, weight: .bold),
        image: UIImage? = nil,
        imagePadding: CGFloat = 10,
        imagePlacement: NSDirectionalRectEdge = .leading,
        imagePointSize: CGFloat = 20,
        foregroundColor: UIColor = .white,
        backgroundColor: UIColor = .fiestaGreen,
        contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center,
        size: CGSize = CGSize(width: 230, height: 45)
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        
        if let titleKey {
            let attributedTitle = AttributedString(
                .localized(for: titleKey),
                attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: foregroundColor
                ])
            )
            
            config.attributedTitle = attributedTitle
        }

        let image = image?
            .withTintColor(foregroundColor, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(pointSize: imagePointSize, weight: .semibold)
            )
        
        config.image = image
        config.imagePadding = imagePadding
        config.imagePlacement = imagePlacement
        config.baseForegroundColor = foregroundColor
        config.baseBackgroundColor = backgroundColor
        
        let view = UIButton(configuration: config)
        
        view.snp.makeConstraints { make in
            make.width.height.equalTo(size)
        }
        
        view.configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                switch button.state {
                case .highlighted:
                    button.transform = .init(scaleX: 0.97, y: 0.97)
                default:
                    button.transform = .identity
                }
            }
        }
        
        view.contentHorizontalAlignment = contentHorizontalAlignment
        
        return view
    }
    
    static func textLinkButton(
        text: String,
        textStyle: UIFont.TextStyle = .body,
        color: UIColor = .lemonYellow
    ) -> UIButton {
        var config = UIButton.Configuration.plain()
        
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont(textStyle: textStyle, weight: .bold, italic: true),
                .foregroundColor: color
            ]
        )
        
        let chevronAttachment = NSTextAttachment()
        chevronAttachment.image = UIImage(systemName: "chevron.right")?
            .withTintColor(color, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
                
        chevronAttachment.bounds = CGRect(
            x: 0,
            y: (UIFont.preferredFont(forTextStyle: textStyle).descender + 2),
            width: 11,
            height: 14
        )
    
        let chevronString = NSAttributedString(attachment: chevronAttachment)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(chevronString)
        attributedText.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: color
        ], range: .init(location: 0, length: attributedText.length))
        
        config.attributedTitle = AttributedString(attributedText)
        
        config.baseForegroundColor = color
        
        let button = UIButton(configuration: config)
        
        button.configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                switch button.state {
                case .highlighted:
                    button.alpha = 0.6
                    button.transform = .init(scaleX: 0.97, y: 0.97)
                default:
                    button.alpha = 1
                    button.transform = .identity
                }
            }
        }
        
        return button
    }
}
