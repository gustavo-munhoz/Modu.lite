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
        StaticConfiguration(
            kind: Self.kind,
            provider: MainWidgetProvider()) { entry in
                MainWidgetView(entry: entry)
                    .containerBackground(
                        .black,
                        for: .widget
                    )
                
            }
            .configurationDisplayName("Main Widget")
            .supportedFamilies([.systemLarge])
    }
}
