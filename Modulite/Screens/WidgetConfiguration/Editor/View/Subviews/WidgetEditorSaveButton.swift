//
//  WidgetEditorSaveButton.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/09/24.
//

import UIKit

class WidgetEditorSaveButton: UIButton {
    
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
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .fiestaGreen
        
        config.attributedTitle = AttributedString(
            .localized(for: .widgetEditorViewSaveWidgetButton),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .bold),
                .foregroundColor: UIColor.white
            ])
        )
        
        config.imagePlacement = .leading
        config.image = UIImage(systemName: "envelope")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .bold)
        config.baseForegroundColor = .white
        
        self.configuration = config
        self.layer.cornerRadius = 0
    }
    
    // MARK: - Appereance updating
    
    func setToEditingState() {
        var config = self.configuration
        config?.attributedTitle = AttributedString(
            .localized(for: .save).uppercased(),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .bold),
                .foregroundColor: UIColor.white
            ])
        )
        self.configuration = config
    }
}
