//
//  ShieldContentFactory.swift
//  Modulite
//
//  Created by André Wozniack on 24/10/24.
//

import UIKit

class ShieldContentFactory {
    
    static func createRandom(for app: String) -> ShieldContent {
        let content = ShieldConfigurationTexts.allCasesFor(app: app).randomElement()!
        
        return ShieldContent(
            image: content.associatedImage,
            title: .localized(for: content),
            buttonText: .localized(for: ShieldConfigurationTexts.actionButtonTitle)
        )
    }
    
}

struct ShieldContent {
    let image: UIImage
    let title: String
    let buttonText: String
}

enum ShieldConfigurationTexts: LocalizedKeyProtocol {
    
    case actionButtonTitle
    
    case shieldContent1(appName: String)
    case shieldContent2(appName: String)
    case shieldContent3(appName: String)
    case shieldContent4(appName: String)
    case shieldContent5(appName: String)
    case shieldContent6(appName: String)
    case shieldContent7(appName: String)
    case shieldContent8(appName: String)
    case shieldContent9(appName: String)
    case shieldContent10(appName: String)
    case shieldContent11(appName: String)
    case shieldContent12(appName: String)
    case shieldContent13(appName: String)
    case shieldContent14(appName: String)
    case shieldContent15(appName: String)
    case shieldContent16(appName: String)
    case shieldContent17(appName: String)
    case shieldContent18(appName: String)
    case shieldContent19(appName: String)
    
    var associatedImage: UIImage {
        UIImage(named: key)!
    }
    
    static func allCasesFor(app: String) -> [ShieldConfigurationTexts] {
        [
            .shieldContent1(appName: app),
            .shieldContent2(appName: app),
            .shieldContent3(appName: app),
            .shieldContent4(appName: app),
            .shieldContent5(appName: app),
            .shieldContent6(appName: app),
            .shieldContent7(appName: app),
            .shieldContent8(appName: app),
            .shieldContent9(appName: app),
            .shieldContent10(appName: app),
            .shieldContent11(appName: app),
            .shieldContent12(appName: app),
            .shieldContent13(appName: app),
            .shieldContent14(appName: app),
            .shieldContent15(appName: app),
            .shieldContent16(appName: app),
            .shieldContent17(appName: app),
            .shieldContent18(appName: app),
            .shieldContent19(appName: app)
        ]
    }
}
