//
//  WidgetModule.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public class WidgetModule {
    
    // MARK: - Properties
    public var position: Int
    public var style: ModuleStyle
    public let appName: String?
    public let urlScheme: URL?
    public var color: UIColor
    
    var isEmpty: Bool { appName == nil }
    
    public var blendedImage: UIImage {
        style.getFinalModuleImage(color: color)
    }
    
    // MARK: - Initializers
    public init(
        style: ModuleStyle,
        position: Int,
        appName: String?,
        urlScheme: URL?,
        color: UIColor
    ) {
        self.style = style
        self.position = position
        self.appName = appName
        self.urlScheme = urlScheme
        self.color = color
    }
    
    // MARK: - Helper functions
    public func getBottomOffset() -> CGFloat {
        style.textConfiguration.bottomOffset ?? 0
    }
    
    public func canSetColor(to color: UIColor) -> Bool {
        style.filterColors.contains(color)
    }
    
    func availableColors() -> [UIColor] {
        style.filterColors
    }
}

extension WidgetModule {
    static func createEmpty(
        of style: WidgetStyle,
        type: WidgetType,
        at position: Int
    ) -> WidgetModule {
        WidgetModule(
            style: style.getEmptyModuleStyle(for: type),
            position: position,
            appName: nil,
            urlScheme: nil,
            color: .clear
        )
    }
}

extension Array where Element: WidgetModule {
    public mutating func replace(at position: Int, with module: Element) {
        replaceSubrange(
            position...position,
            with: [module]
        )
    }
}
