//
//  AuxiliaryWidget.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import SwiftUI
import WidgetKit

struct AuxiliaryWidget: Widget {
    static private let kind = "AuxWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: Self.kind,
            intent: SelectAuxWidgetConfigurationIntent.self,
            provider: AuxWidgetIntentProvider(),
            content: { entry in
                AuxWidgetView(entry: entry)
            }
        )
        .contentMarginsDisabled()
        // TODO: Use default localizable key pattern
        .configurationDisplayName("Auxiliary Widget")
        .supportedFamilies([.systemMedium])
    }
}
