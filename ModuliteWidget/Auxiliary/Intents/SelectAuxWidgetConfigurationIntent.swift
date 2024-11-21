//
//  SelectAuxWidgetConfigurationIntent.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import AppIntents

struct SelectAuxWidgetConfigurationIntent: WidgetConfigurationIntent {
    // TODO: Use default localizable key pattern
    static var title: LocalizedStringResource = "Select Widget Configuration"
    static var description = IntentDescription("Selects the widget configuration to display.")

    @Parameter(title: "Widget")
    var widgetConfiguration: AuxWidgetConfigurationEntity?

    init() {}

    init(widgetConfiguration: AuxWidgetConfigurationEntity) {
        self.widgetConfiguration = widgetConfiguration
    }
}
