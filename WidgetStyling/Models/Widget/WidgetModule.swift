//
//  WidgetModule.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public class WidgetModule {
    
    // MARK: - Properties
    var position: Int
    var style: ModuleStyle
    let appName: String?
    let urlScheme: URL?
    var color: UIColor
    
    var isEmpty: Bool { appName == nil }
    
    // MARK: - Initializers
    init(
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
