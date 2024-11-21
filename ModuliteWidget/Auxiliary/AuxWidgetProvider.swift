//
//  AuxWidgetProvider.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import SwiftUI
import WidgetKit
import AppIntents
import WidgetStyling

struct AuxWidgetIntentProvider: AppIntentTimelineProvider {
    typealias Intent = SelectAuxWidgetConfigurationIntent
    typealias Entry = AuxWidgetEntry
    
    init() {
        Task {
            await SubscriptionManager.shared.initialize()
            WidgetCenter.shared.reloadTimelines(ofKind: "AuxWidget")
        }   
    }
    
    func placeholder(in context: Context) -> AuxWidgetEntry {
        AuxWidgetEntry(date: .now, configuration: nil)
    }
    
    func snapshot(
        for configuration: SelectAuxWidgetConfigurationIntent,
        in context: Context
    ) async -> AuxWidgetEntry {
        placeholder(in: context)
    }
    
    func timeline(
        for configuration: SelectAuxWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<AuxWidgetEntry> {
        guard let widgetConfiguration = configuration.widgetConfiguration,
              let widgetData = await loadAuxWidgetData(for: widgetConfiguration.id) else {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .atEnd)
        }
        
        let entry = AuxWidgetEntry(date: .now, configuration: widgetData)
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    private func loadAuxWidgetData(for id: UUID) async -> AuxWidgetConfigurationData? {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        let widgets = CoreDataPersistenceController.shared.fetchAuxWidgets(predicate: predicate)
        
        if let widget = widgets.first {
            return convertToAuxWidgetConfigurationData(widget)
        }
        
        return nil
    }
    
    private func convertToAuxWidgetConfigurationData(
        _ schema: WidgetSchema
    ) -> AuxWidgetConfigurationData {
        let background = schema.getBackground()
        
        let moduleImages = FileManagerImagePersistenceController.shared.getModuleImages(
            for: schema.id
        )
        
        let modules = schema.modules
            .sorted(by: { $0.position < $1.position })
            .map(
            { module in
                AuxWidgetModuleData(
                    id: UUID(),
                    index: Int(module.position),
                    image: Image(uiImage: moduleImages[Int(module.position)]),
                    associatedURLScheme: module.urlScheme
                )
        })
        
        return AuxWidgetConfigurationData(
            id: schema.id,
            name: schema.name ?? "Widget",
            background: background,
            modules: modules
        )
    }
}
