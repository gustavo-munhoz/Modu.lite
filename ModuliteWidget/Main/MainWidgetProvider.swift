//
//  MainWidgetProvider.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import SwiftUI
import WidgetKit
import AppIntents

struct MainWidgetProvider: TimelineProvider {
    // MARK: - TimelineProvider
    
    init() {
        ValueTransformer.setValueTransformer(
            UIColorValueTransformer(),
            forName: NSValueTransformerName("UIColorValueTransformer")
        )
    }
    
    func placeholder(in context: Context) -> MainWidgetEntry {
        MainWidgetEntry(
            date: .now,
            configuration: MainWidgetConfigurationData(
                id: UUID(),
                name: "Placeholder Widget",
                background: .color(.systemBackground),
                modules: []
            )
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MainWidgetEntry) -> Void) {
        if context.isPreview {
            let entry = placeholder(in: context)
            completion(entry)
            return
        }
                
        let configurations = CoreDataPersistenceController.shared.fetchWidgets()
        
        guard let config = configurations.first else {
            let entry = placeholder(in: context)
            completion(entry)
            return
        }
        
        let convertedConfig = convertToMainWidgetConfigurationData(config)
        let entry = MainWidgetEntry(date: Date(), configuration: convertedConfig)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MainWidgetEntry>) -> Void) {
        let configurations = CoreDataPersistenceController.shared.fetchWidgets()
        
        guard let config = configurations.first else {
            let placeholderEntry = placeholder(in: context)
            let timeline = Timeline(entries: [placeholderEntry], policy: .atEnd)
            completion(timeline)
            return
        }
        
        let convertedConfig = convertToMainWidgetConfigurationData(config)
        
        let entry = MainWidgetEntry(date: .now, configuration: convertedConfig)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    // MARK: - Helper methods
    private func convertToMainWidgetConfigurationData(
        _ configuration: PersistableWidgetConfiguration
    ) -> MainWidgetConfigurationData {
        
        let moduleImages = FileManagerImagePersistenceController.shared.getModuleImages(
            for: configuration.id
        )
        
        let modules = (configuration.modules.allObjects as? [PersistableModuleConfiguration])?
            .sorted(by: { $0.index < $1.index })
            .map(
            { module in
                MainWidgetModuleData(
                    id: UUID(),
                    index: Int(module.index),
                    image: Image(uiImage: moduleImages[Int(module.index)]),
                    associatedURLScheme: module.urlScheme
                )
        }) ?? []
        
        return MainWidgetConfigurationData(
            id: configuration.id,
            name: configuration.name ?? "Widget",
            // FIXME: Get background from configuration
            background: .color(.black),
            modules: modules
        )
    }
}

struct MainWidgetIntentProvider: AppIntentTimelineProvider {
    typealias Intent = SelectMainWidgetConfigurationIntent
    typealias Entry = MainWidgetEntry
    
    func placeholder(in context: Context) -> MainWidgetEntry {
        MainWidgetEntry(
            date: .now,
            configuration: MainWidgetConfigurationData(
                id: UUID(),
                name: "Placeholder Widget",
                background: .color(.systemBackground),
                modules: []
            )
        )
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
              let widgetData = await loadWidgetData(for: widgetConfiguration.id) else {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .atEnd)
        }
        
        let entry = MainWidgetEntry(date: .now, configuration: widgetData)
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    private func loadWidgetData(for id: UUID) async -> MainWidgetConfigurationData? {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        let widgets = CoreDataPersistenceController.shared.fetchWidgets(predicate: predicate)
        
        if let widget = widgets.first {
            return convertToMainWidgetConfigurationData(widget)
        }
        
        return nil
    }
    
    private func convertToMainWidgetConfigurationData(
        _ configuration: PersistableWidgetConfiguration
    ) -> MainWidgetConfigurationData {
        
        let moduleImages = FileManagerImagePersistenceController.shared.getModuleImages(
            for: configuration.id
        )
        
        let modules = (configuration.modules.allObjects as? [PersistableModuleConfiguration])?
            .sorted(by: { $0.index < $1.index })
            .map(
            { module in
                MainWidgetModuleData(
                    id: UUID(),
                    index: Int(module.index),
                    image: Image(uiImage: moduleImages[Int(module.index)]),
                    associatedURLScheme: module.urlScheme
                )
        }) ?? []
        
        return MainWidgetConfigurationData(
            id: configuration.id,
            name: configuration.name ?? "Widget",
            // FIXME: Get background from configuration
            background: .color(.black),
            modules: modules
        )
    }
}
