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
        var config = ButtonFactory.mediumButtonConfiguration(
            titleKey: String.LocalizedKey.widgetEditorViewWallpaperButton,
            image: UIImage(systemName: "square.and.arrow.down"),
            backgroundColor: .carrotOrange
        )
        
        config.titleLineBreakMode = .byClipping
        config.contentInsets = .init(top: 8, leading: 8, bottom: 10, trailing: 10)
        configuration = config
        
        configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            
            UIView.animate(withDuration: 0.1) {
                switch button.state {
                case .highlighted:
                    button.alpha = 0.9
                    button.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                    
                case .disabled:
                    button.alpha = 0.9
                    updatedConfig?.background.backgroundColor = .systemGray2
                    updatedConfig?.attributedTitle = AttributedString(
                        .localized(for: .widgetEditorViewWallpaperButtonSaved),
                        attributes: AttributeContainer([
                            .font: UIFont.spaceGrotesk(textStyle: .title3, weight: .bold),
                            .foregroundColor: UIColor.white
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
