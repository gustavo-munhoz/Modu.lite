//
//  WidgetStyleFactory.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit
import SwiftData

class WidgetStyleFactory {
    
    static func styleForKey(_ key: WidgetStyleKey) -> WidgetStyle {
        switch key {
        case .analog:
            return createAnalogStyle()
            
        case .tapedeck:
            return createTapedeckStyle()
        }
    }

}

// MARK: - Analog
extension WidgetStyleFactory {
    private static func createAnalogStyle() -> WidgetStyle {
        let textConfig = ModuleAppNameTextConfiguration()
            .font(UIFont(textStyle: .caption2, weight: .semibold))
            .textColor(.iceCold)
            .shadow(color: .iceCold, blurRadius: 5)
            .textCase(.lower)
            .removingSpaces()
            .preffix(".")

        let style = WidgetStyle(
            key: .analog,
            name: .localized(for: .widgetStyleNameAnalog),
            previewImage: .analogPreview,
            background: .color(.black),
            colors: [.white, .eggYolk, .cupcake, .sweetTooth, .sugarMint, .burntEnds],
            defaultColor: .white,
            textConfiguration: textConfig,
            blockedScreenWallpaperImage: .analogWallpaper,
            homeScreenWallpaperImage: .analogWallpaper,
            imageBlendMode: .plusDarker
        )
        style.isPurchased = true
//        style.isPurchased = PurchasedSkinsManager.shared.isSkinPurchased(style.name)
        
        let moduleStyles = [
            ModuleStyle(from: style, key: .analogRegular),
            ModuleStyle(from: style, key: .analogKnob),
            ModuleStyle(from: style, key: .analogScreen),
            ModuleStyle(from: style, key: .analogSound),
            ModuleStyle(from: style, key: .analogSwitch)
        ]

        style.setModuleStyles(to: moduleStyles)
        style.setEmptyStyle(to: ModuleStyle(from: style, key: .analogEmpty))
        
        return style
    }
}

// MARK: - Tapedeck
extension WidgetStyleFactory {
    private static func createTapedeckStyle() -> WidgetStyle {
        let textConfig = ModuleAppNameTextConfiguration()
            .font(UIFont(textStyle: .caption2, weight: .semibold))
            .textColor(.white)
            .textCase(.upper)
        
        let style = WidgetStyle(
            key: .tapedeck,
            name: .localized(for: .widgetStyleNameTapedeck),
            previewImage: .tapedeckMainPreview,
            background: .color(.burntCoconut),
            colors: [.monsterGreen, .orangeJuice, .cupcake, .sweetTooth, .sugarMint, .ketchupRed],
            defaultColor: .orangeJuice,
            textConfiguration: textConfig,
            blockedScreenWallpaperImage: .tapedeckWallpaper,
            homeScreenWallpaperImage: .tapedeckWallpaper,
            imageBlendMode: .hue
        )
        style.isPurchased = true
//        style.isPurchased = PurchasedSkinsManager.shared.isSkinPurchased(style.name)
        
        let moduleStyles = [
            ModuleStyle(from: style, key: .tapedeckMain8seg),
            ModuleStyle(from: style, key: .tapedeckMainPower),
            ModuleStyle(from: style, key: .tapedeckMainSound),
            ModuleStyle(from: style, key: .tapedeckMainSlider),
            ModuleStyle(from: style, key: .tapedeckMainSelector)
        ]
        
        style.setModuleStyles(to: moduleStyles)
        style.setEmptyStyle(to: ModuleStyle(from: style, key: .tapedeckMainEmpty))
        
        return style
    }
}
