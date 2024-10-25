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
        let content = ShieldContentFactory.createRandom(for: application.localizedDisplayName ?? "App")
        return ShieldConfigurationBuilder()
            .withContent(content)
            .build()
    }
    
    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        let content = ShieldContentFactory.createRandom(for: application.localizedDisplayName ?? "App")
        return ShieldConfigurationBuilder()
            .withContent(content)
            .build()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        let content = ShieldContentFactory.createRandom(
            for: webDomain.domain ?? "Domain"
        )
        return ShieldConfigurationBuilder()
            .withContent(content)
            .build()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        let content = ShieldContentFactory.createRandom(for: webDomain.domain ?? "Domain")
        return ShieldConfigurationBuilder()
            .withContent(content)
            .build()
    }
}
