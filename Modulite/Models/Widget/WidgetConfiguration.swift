//
//  WidgetModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//
import SwiftUI
import UIKit
import SwiftData

/// Manages the overall configuration of a widget, including its background and modules.

class WidgetConfiguration {
    let widgetStyle: WidgetStyle
    var modules: [ModuleConfiguration]
    
    var availableStyles: [ModuleStyle] {
        widgetStyle.styles
    }
    
    var availableColors: [UIColor] {
        widgetStyle.colors
    }
    
    init(
        style: WidgetStyle,
        modules: [ModuleConfiguration]
    ) {
        self.widgetStyle = style
        self.modules = modules
    }
}

@Model
class WidgetPersistableConfiguration {
    @Attribute(.unique) let id: UUID
    let widgetStyleKey: WidgetStyleKey
    let modules: [ModulePersistableConfiguration]
    
    init(id: UUID, widgetStyleKey: WidgetStyleKey, modules: [ModulePersistableConfiguration]) {
        self.id = id
        self.widgetStyleKey = widgetStyleKey
        self.modules = modules
    }
}

extension WidgetConfiguration {
    convenience init(persistableConfiguration config: WidgetPersistableConfiguration) {
        let style = WidgetStyleFactory.styleForKey(config.widgetStyleKey)
        
        self.init(
            style: style,
            modules: config.modules.map {
                ModuleConfiguration(
                    widgetStyle: style,
                    persistedConfiguration: $0
                )
            }
        )
    }
}
