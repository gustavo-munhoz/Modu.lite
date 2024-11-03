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
        
        let config = ButtonFactory.mediumButtonConfiguration(
            titleKey: WidgetEditorLocalizedTexts.widgetEditorDeleteButtonTitle,
            image: UIImage(systemName: "trash"),
            backgroundColor: .ketchupRed
        )
    
        self.configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                if button.state == .highlighted {
                    button.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                } else {
                    button.transform = .identity
                }
            }
        }
        
        configuration = config
    }
}
