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
            previewImage: UIImage(named: "analogPreview")!,
            background: .color(.black),
            colors: [.white, .eggYolk, .cupcake, .sweetTooth, .sugarMint, .burntEnds],
            textConfiguration: textConfig,
            blockedScreenWallpaperImage: UIImage(named: "analogWallpaper")!,
            homeScreenWallpaperImage: UIImage(named: "analogWallpaper")!
        )
        
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
    
    private static func createTapedeckStyle() -> WidgetStyle {
        let textConfig = ModuleAppNameTextConfiguration()
            .font(UIFont(textStyle: .caption2, weight: .semibold))
            .textColor(.white)
            .textCase(.upper)
        
        let style = WidgetStyle(
            key: .tapedeck,
            name: .localized(for: .widgetStyleNameTapedeck),
            previewImage: UIImage(named: "tapedeckPreview")!,
            background: .color(.black),
            textConfiguration: textConfig,
            blockedScreenWallpaperImage: UIImage(named: "tapedeckWallpaper")!,
            homeScreenWallpaperImage: UIImage(named: "tapedeckWallpaper")!
        )
        
        let moduleStyles = [
            ModuleStyle(from: style, key: .tapedeck8seg),
            ModuleStyle(from: style, key: .tapedeckPower),
            ModuleStyle(from: style, key: .tapedeckSelector),
            ModuleStyle(from: style, key: .tapedeckSlider),
            ModuleStyle(from: style, key: .tapedeckSound)
        ]
        
        style.setModuleStyles(to: moduleStyles)
        
        // FIXME: Need to set empty style
        
        return style
    }
}
