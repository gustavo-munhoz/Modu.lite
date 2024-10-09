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
        return ShieldConfigurationBuilder()
            .withTitleText("\(String(describing: application.localizedDisplayName)) Bloqueado", color: .white)
            .withSubtitleText("Acesso negado", color: .white)
            .withPrimaryButtonLabel("Fechar", color: .black)
            .withPrimaryButtonBackgroundColor(.red)
            .withIcon(UIImage(named: "customIcon"))
            .build()
    }
    
    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        return ShieldConfigurationBuilder()
            .withTitleText("Categoria Bloqueada", color: .white)
            .withSubtitleText("Você não pode acessar este conteúdo", color: .gray)
            .withPrimaryButtonLabel("Sair", color: .black)
            .withPrimaryButtonBackgroundColor(.blue)
            .withIcon(UIImage(named: "icon2"))
            .build()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return ShieldConfigurationBuilder()
            .withTitleText("\(String(describing: webDomain.domain)) Bloqueado", color: .white)
            .withSubtitleText("Acesso não permitido", color: .white)
            .withPrimaryButtonLabel("Voltar", color: .black)
            .withPrimaryButtonBackgroundColor(.yellow)
            .withIcon(UIImage(named: "icon2"))
            .build()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return ShieldConfigurationBuilder()
            .withTitleText("Categoria Web Bloqueada", color: .white)
            .withSubtitleText("Acesso a este conteúdo está bloqueado", color: .gray)
            .withPrimaryButtonLabel("Entendi", color: .black)
            .withPrimaryButtonBackgroundColor(.red)
            .withIcon(UIImage(named: "icon2"))
            .build()
    }
}
