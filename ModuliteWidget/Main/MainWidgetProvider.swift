//
//  MainWidgetProvider.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import SwiftUI
import WidgetKit
import AppIntents
import WidgetStyling

struct MainWidgetIntentProvider: AppIntentTimelineProvider {
    typealias Intent = SelectMainWidgetConfigurationIntent
    typealias Entry = MainWidgetEntry
    
    func placeholder(in context: Context) -> MainWidgetEntry {
        MainWidgetEntry(date: .now, configuration: nil)
    }
    
    func snapshot(
        for configuration: SelectMainWidgetConfigurationIntent,
        in context: Context
    ) async -> MainWidgetEntry {
        placeholder(in: context)
    }
    
    func timeline(
        for configuration: SelectMainWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<MainWidgetEntry> {
        guard let widgetConfiguration = configuration.widgetConfiguration,
              let widgetData = await loadMainWidgetData(for: widgetConfiguration.id) else {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .atEnd)
        }
        
        let entry = MainWidgetEntry(date: .now, configuration: widgetData)
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    private func loadMainWidgetData(for id: UUID) async -> MainWidgetConfigurationData? {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        let widgets = CoreDataPersistenceController.shared.fetchMainWidgets(predicate: predicate)
        
        if let widget = widgets.first {
            return convertToMainWidgetConfigurationData(widget)
        }
        
        return nil
    }
    
    private func convertToMainWidgetConfigurationData(
        _ schema: WidgetSchema
    ) -> MainWidgetConfigurationData {
        let background = schema.getBackground()
        
        let moduleImages = FileManagerImagePersistenceController.shared.getModuleImages(
            for: schema.id
        )
        
        let modules = schema.modules
            .sorted(by: { $0.position < $1.position })
            .map(
            { module in
                MainWidgetModuleData(
                    id: UUID(),
                    index: Int(module.position),
                    image: Image(uiImage: moduleImages[Int(module.position)]),
                    associatedURLScheme: module.urlScheme
                )
        })
        
        return MainWidgetConfigurationData(
            id: schema.id,
            name: schema.name ?? "Widget",
            background: background,
            modules: modules
        )
    }
}
