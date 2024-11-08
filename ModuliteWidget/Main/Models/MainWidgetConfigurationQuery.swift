//
//  MainWidgetConfigurationQuery.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/09/24.
//

import AppIntents
import CoreData
import WidgetStyling

struct MainWidgetConfigurationQuery: EntityQuery {
    // TODO: Localize strings
    
    func entities(for identifiers: [UUID]) async throws -> [MainWidgetConfigurationEntity] {
        let configurations = try await fetchMainWidgetSchemas(identifiers: identifiers)
        return configurations.map { MainWidgetConfigurationEntity(id: $0.id, name: $0.name ?? "Unnamed Widget") }
    }

    func suggestedEntities() async throws -> [MainWidgetConfigurationEntity] {
        let configurations = try await fetchAllMainWidgetSchemas()
        return configurations.map { MainWidgetConfigurationEntity(id: $0.id, name: $0.name ?? "Unnamed Widget") }
    }

    func defaultResult() async -> MainWidgetConfigurationEntity? {
        try? await suggestedEntities().first
    }

    private func fetchMainWidgetSchemas(identifiers: [UUID]) async throws -> [WidgetSchema] {
        let predicate = NSPredicate(format: "id IN %@", identifiers.map { $0.uuidString })
        return CoreDataPersistenceController.shared.fetchMainWidgets(predicate: predicate)
    }
    
    private func fetchAllMainWidgetSchemas() async throws -> [WidgetSchema] {
        CoreDataPersistenceController.shared.fetchMainWidgets()
    }
}
