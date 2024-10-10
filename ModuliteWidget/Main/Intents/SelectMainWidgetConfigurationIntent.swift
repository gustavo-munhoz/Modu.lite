//
//  SelectMainWidgetConfigurationIntent.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/09/24.
//

import AppIntents

struct SelectMainWidgetConfigurationIntent: WidgetConfigurationIntent {
    // TODO: Use default localizable key pattern
    static var title: LocalizedStringResource = "Select Widget Configuration"
    static var description = IntentDescription("Selects the widget configuration to display.")

    @Parameter(title: "Widget")
    var widgetConfiguration: MainWidgetConfigurationEntity?

    init() {}

    init(widgetConfiguration: MainWidgetConfigurationEntity) {
        self.widgetConfiguration = widgetConfiguration
    }
}
