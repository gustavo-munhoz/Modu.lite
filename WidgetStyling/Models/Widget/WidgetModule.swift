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
        do {
            return try style.blendedImage(with: color)
        } catch {
            return style.image
        }
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
    func canSetColor(to color: UIColor) -> Bool {
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
            style: style.getEmptyStyle(for: type),
            position: position,
            appName: nil,
            urlScheme: nil,
            color: .clear
        )
    }
}

extension Array where Element: WidgetModule {
    mutating func replace(at position: Int, with module: Element) {
        replaceSubrange(
            position...position,
            with: [module]
        )
    }
}
