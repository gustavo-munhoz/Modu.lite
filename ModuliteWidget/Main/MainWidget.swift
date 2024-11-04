//
//  MainWidget.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import SwiftUI
import WidgetKit

struct MainWidget: Widget {
    static private let kind = "MainWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: Self.kind,
            intent: SelectMainWidgetConfigurationIntent.self,
            provider: MainWidgetIntentProvider(),
            content: { entry in
                MainWidgetView(entry: entry)
            }
        )
        .contentMarginsDisabled()
        // TODO: Use default localizable key pattern
        .configurationDisplayName("Main Widget")
        .supportedFamilies([.systemLarge])
    }
}
