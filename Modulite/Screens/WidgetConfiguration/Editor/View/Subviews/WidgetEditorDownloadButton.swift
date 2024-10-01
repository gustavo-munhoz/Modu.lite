//
//  WidgetEditorDownloadButton.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/09/24.
//

import UIKit

class WidgetEditorDownloadButton: UIButton {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    
    private func setupButton() {
        var config = UIButton.Configuration.bordered()
        
        config.attributedTitle = AttributedString(
            .localized(for: .widgetEditorViewWallpaperButton),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .bold),
                .foregroundColor: UIColor.textPrimary
            ])
        )
        
        config.titleAlignment = .center
        config.titleLineBreakMode = .byClipping
        
        config.image = UIImage(systemName: "square.and.arrow.down")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        
        config.imagePlacement = .leading
        config.imagePadding = 5
        
        config.baseBackgroundColor = .clear
        
        configuration = config
        
        layer.borderColor = UIColor.carrotOrange.cgColor
        layer.borderWidth = 2
        
        configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            
            UIView.animate(withDuration: 0.1) {
                switch button.state {
                case .highlighted:
                    button.alpha = 0.67
                    button.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                    
                case .disabled:
                    button.alpha = 0.67
                    button.layer.borderColor = UIColor.gray.cgColor
                    updatedConfig?.attributedTitle = AttributedString(
                        .localized(for: .widgetEditorViewWallpaperButtonSaved),
                        attributes: AttributeContainer([
                            .font: UIFont(textStyle: .body, weight: .bold),
                            .foregroundColor: UIColor.textPrimary
                        ])
                    )
                    button.configuration = updatedConfig
                    
                default:
                    button.alpha = 1
                    button.transform = .identity
                }
            }
        }
    }
}
