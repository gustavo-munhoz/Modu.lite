//
//  WidgetEditorDeleteButton.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/09/24.
//

import UIKit

class WidgetEditorDeleteButton: UIButton {
    
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
        config.baseBackgroundColor = .ketchupRed
        
        config.attributedTitle = AttributedString(
            .localized(for: .delete).uppercased(),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .bold),
                .foregroundColor: UIColor.white
            ])
        )
        
        config.imagePlacement = .leading
        config.image = UIImage(systemName: "trash")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .bold)
        config.baseForegroundColor = .white
        
        configuration = config
        layer.cornerRadius = 0
    }
}
