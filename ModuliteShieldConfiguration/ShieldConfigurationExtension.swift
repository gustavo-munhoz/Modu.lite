//
//  ShieldConfigurationExtension.swift
//  ModuliteShieldConfiguration
//
//  Created by André Wozniack on 02/10/24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
            
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.dark,
            backgroundColor: UIColor.black,
            icon: UIImage(named: "icon2"),
            title: ShieldConfiguration.Label(
                text: "BLOQUEADO",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "PERDEU PLAYBOY",
                color: .white
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "VAZA",
                color: .black
            ),
            primaryButtonBackgroundColor: .yellow
        )
    }
    
    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.dark,
            backgroundColor: UIColor.black,
            icon: UIImage(named: "icon2"),
            title: ShieldConfiguration.Label(
                text: "BLOQUEADO",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "PERDEU PLAYBOY",
                color: .white
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "VAZA",
                color: .black
            ),
            primaryButtonBackgroundColor: .yellow
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.dark,
            backgroundColor: UIColor.black,
            icon: UIImage(named: "icon2"),
            title: ShieldConfiguration.Label(
                text: "BLOQUEADO",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "PERDEU PLAYBOY",
                color: .white
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "VAZA",
                color: .black
            ),
            primaryButtonBackgroundColor: .yellow
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.dark,
            backgroundColor: UIColor.black,
            icon: UIImage(named: "icon2"),
            title: ShieldConfiguration.Label(
                text: "BLOQUEADO",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "PERDEU PLAYBOY",
                color: .white
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "VAZA",
                color: .black
            ),
            primaryButtonBackgroundColor: .yellow
        )
    }
}
