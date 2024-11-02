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
    private var icon: UIImage?
    private var titleText: String = ""
    private var titleColor: UIColor = .white
    private var primaryButtonLabelText: String = ""
    private var primaryButtonLabelColor: UIColor = .black
    private var primaryButtonBackgroundColor: UIColor = .yellow
    
    func withContent(_ content: ShieldContent) -> ShieldConfigurationBuilder {
        self.icon = content.image.resized(to: CGSize(width: 200, height: 200))
        self.titleText = content.title
        self.primaryButtonLabelText = content.buttonText
        return self
    }

    func withBackgroundBlurStyle(_ style: UIBlurEffect.Style) -> ShieldConfigurationBuilder {
        self.backgroundBlurStyle = style
        return self
    }
    
    func withBackgroundColor(_ color: UIColor) -> ShieldConfigurationBuilder {
        self.backgroundColor = color
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
            primaryButtonLabel: ShieldConfiguration.Label(
                text: primaryButtonLabelText,
                color: primaryButtonLabelColor
            ),
            primaryButtonBackgroundColor: primaryButtonBackgroundColor
        )
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
