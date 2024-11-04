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
            
        case .retromacWhite:
            return createRetromacStyle()
            
        case .retromacGreen:
            return createRetromacGreenStyle()
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
            imageBlendMode: .plusDarker,
            isPurchased: true,
            isGrantedByPlus: false
        )
        
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
            .font(.archivo(textStyle: .caption2))
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
            imageBlendMode: .hue,
            isPurchased: true,
            isGrantedByPlus: false
        )
        
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

extension WidgetStyleFactory {
    private static func createRetromacStyle() -> WidgetStyle {
        let textConfig = ModuleAppNameTextConfiguration()
            .font(.pixelOperator(textStyle: .caption2))
            .textColor(.black)
            .textCase(.capitalized)
        
        let style = WidgetStyle(
            key: .retromacWhite,
            name: .localized(for: .widgetStyleNameRetromac),
            previewImage: .retromacWhiteWidgetPreview,
            background: .color(.white),
            colors: [.black],
            defaultColor: .black,
            textConfiguration: textConfig,
            blockedScreenWallpaperImage: .retromacWhiteBlockedWallpaper,
            homeScreenWallpaperImage: .retromacWhiteWallpaper,
            isPurchased: true,
            isGrantedByPlus: false
        )
        
        let modules = [
            ModuleStyle(from: style, key: .retromacMainBook),
            ModuleStyle(from: style, key: .retromacMainCalculator),
            ModuleStyle(from: style, key: .retromacMainCamera),
            ModuleStyle(from: style, key: .retromacMainCar),
            ModuleStyle(from: style, key: .retromacMainChart),
            ModuleStyle(from: style, key: .retromacMainClock),
            ModuleStyle(from: style, key: .retromacMainCloud),
            ModuleStyle(from: style, key: .retromacMainDoc),
            ModuleStyle(from: style, key: .retromacMainEmail),
            ModuleStyle(from: style, key: .retromacMainGame),
            ModuleStyle(from: style, key: .retromacMainGear),
            ModuleStyle(from: style, key: .retromacMainHeart),
            ModuleStyle(from: style, key: .retromacMainMail),
            ModuleStyle(from: style, key: .retromacMainMap),
            ModuleStyle(from: style, key: .retromacMainMessage),
            ModuleStyle(from: style, key: .retromacMainMoney),
            ModuleStyle(from: style, key: .retromacMainMusic),
            ModuleStyle(from: style, key: .retromacMainPet),
            ModuleStyle(from: style, key: .retromacMainPhone),
            ModuleStyle(from: style, key: .retromacMainPhoto),
            ModuleStyle(from: style, key: .retromacMainReading),
            ModuleStyle(from: style, key: .retromacMainSmile),
            ModuleStyle(from: style, key: .retromacMainSocial),
            ModuleStyle(from: style, key: .retromacMainSparkle),
            ModuleStyle(from: style, key: .retromacMainTelephone),
            ModuleStyle(from: style, key: .retromacMainWeb),
            ModuleStyle(from: style, key: .retromacMainWork)
        ]
        
        style.setModuleStyles(to: modules)
        style.setEmptyStyle(to: ModuleStyle(from: style, key: .retromacMainEmpty))
        
        return style
    }
    
    private static func createRetromacGreenStyle() -> WidgetStyle {
        let textConfig = ModuleAppNameTextConfiguration()
            .font(.pixelOperator(textStyle: .caption2))
            .textColor(.black)
            .textCase(.capitalized)
        
        let style = WidgetStyle(
            key: .retromacGreen,
            name: .localized(for: .widgetStyleNameRetromacGreen),
            previewImage: .retromacGreenWidgetPreview,
            background: .color(.retromacGreen),
            colors: [.black],
            defaultColor: .black,
            textConfiguration: textConfig,
            blockedScreenWallpaperImage: .retromacGreenBlockedWallpaper,
            homeScreenWallpaperImage: .retromacGreenWallpaper,
            isPurchased: true,
            isGrantedByPlus: false
        )
        
        let modules = [
            ModuleStyle(from: style, key: .retromacMainBook),
            ModuleStyle(from: style, key: .retromacMainCalculator),
            ModuleStyle(from: style, key: .retromacMainCamera),
            ModuleStyle(from: style, key: .retromacMainCar),
            ModuleStyle(from: style, key: .retromacMainChart),
            ModuleStyle(from: style, key: .retromacMainClock),
            ModuleStyle(from: style, key: .retromacMainCloud),
            ModuleStyle(from: style, key: .retromacMainDoc),
            ModuleStyle(from: style, key: .retromacMainEmail),
            ModuleStyle(from: style, key: .retromacMainGame),
            ModuleStyle(from: style, key: .retromacMainGear),
            ModuleStyle(from: style, key: .retromacMainHeart),
            ModuleStyle(from: style, key: .retromacMainMail),
            ModuleStyle(from: style, key: .retromacMainMap),
            ModuleStyle(from: style, key: .retromacMainMessage),
            ModuleStyle(from: style, key: .retromacMainMoney),
            ModuleStyle(from: style, key: .retromacMainMusic),
            ModuleStyle(from: style, key: .retromacMainPet),
            ModuleStyle(from: style, key: .retromacMainPhone),
            ModuleStyle(from: style, key: .retromacMainPhoto),
            ModuleStyle(from: style, key: .retromacMainReading),
            ModuleStyle(from: style, key: .retromacMainSmile),
            ModuleStyle(from: style, key: .retromacMainSocial),
            ModuleStyle(from: style, key: .retromacMainSparkle),
            ModuleStyle(from: style, key: .retromacMainTelephone),
            ModuleStyle(from: style, key: .retromacMainWeb),
            ModuleStyle(from: style, key: .retromacMainWork)
        ]
        
        style.setModuleStyles(to: modules)
        style.setEmptyStyle(to: ModuleStyle(from: style, key: .retromacMainEmpty))
        
        return style
    }
}
