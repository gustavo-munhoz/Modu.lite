//
//  ShieldConfigurationBuilder.swift
//  Modulite
//
//  Created by André Wozniack on 07/10/24.
//

import Foundation
import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationBuilder {
    private var backgroundBlurStyle: UIBlurEffect.Style = .dark
    private var backgroundColor: UIColor = .black
    private var icon: UIImage? = UIImage(named: "icon2")
    private var titleText: String = "BLOQUEADO"
    private var titleColor: UIColor = .white
    private var subtitleText: String = "PERDEU PLAYBOY"
    private var subtitleColor: UIColor = .white
    private var primaryButtonLabelText: String = "VAZA"
    private var primaryButtonLabelColor: UIColor = .black
    private var primaryButtonBackgroundColor: UIColor = .yellow
    
    // Métodos `with` para configurar os valores de cada campo
    func withBackgroundBlurStyle(_ style: UIBlurEffect.Style) -> ShieldConfigurationBuilder {
        self.backgroundBlurStyle = style
        return self
    }
    
    func withBackgroundColor(_ color: UIColor) -> ShieldConfigurationBuilder {
        self.backgroundColor = color
        return self
    }
    
    func withIcon(_ icon: UIImage?) -> ShieldConfigurationBuilder {
        self.icon = icon
        return self
    }
    
    func withTitleText(_ text: String, color: UIColor = .white) -> ShieldConfigurationBuilder {
        self.titleText = text
        self.titleColor = color
        return self
    }
    
    func withSubtitleText(_ text: String, color: UIColor = .white) -> ShieldConfigurationBuilder {
        self.subtitleText = text
        self.subtitleColor = color
        return self
    }
    
    func withPrimaryButtonLabel(_ text: String, color: UIColor = .black) -> ShieldConfigurationBuilder {
        self.primaryButtonLabelText = text
        self.primaryButtonLabelColor = color
        return self
    }
    
    func withPrimaryButtonBackgroundColor(_ color: UIColor) -> ShieldConfigurationBuilder {
        self.primaryButtonBackgroundColor = color
        return self
    }

    func build() -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: backgroundBlurStyle,
            backgroundColor: backgroundColor,
            icon: icon,
            title: ShieldConfiguration.Label(
                text: titleText,
                color: titleColor
            ),
            subtitle: ShieldConfiguration.Label(
                text: subtitleText,
                color: subtitleColor
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: primaryButtonLabelText,
                color: primaryButtonLabelColor
            ),
            primaryButtonBackgroundColor: primaryButtonBackgroundColor
        )
    }
}
