//
//  MainWidgetConfigurationQuery.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/09/24.
//

import AppIntents
import CoreData

struct MainWidgetConfigurationQuery: EntityQuery {
    // TODO: Localize strings
    
    func entities(for identifiers: [UUID]) async throws -> [MainWidgetConfigurationEntity] {
        let configurations = try await fetchWidgetConfigurations(identifiers: identifiers)
        return configurations.map { MainWidgetConfigurationEntity(id: $0.id, name: $0.name ?? "Unnamed Widget") }
    }

    func suggestedEntities() async throws -> [MainWidgetConfigurationEntity] {
        let configurations = try await fetchAllWidgetConfigurations()
        return configurations.map { MainWidgetConfigurationEntity(id: $0.id, name: $0.name ?? "Unnamed Widget") }
    }

    func defaultResult() async -> MainWidgetConfigurationEntity? {
        try? await suggestedEntities().first
    }

    private func fetchWidgetConfigurations(identifiers: [UUID]) async throws -> [PersistableWidgetConfiguration] {
        let predicate = NSPredicate(format: "id IN %@", identifiers.map { $0.uuidString })
        return CoreDataPersistenceController.shared.fetchWidgets(predicate: predicate)
    }
    
    private func fetchAllWidgetConfigurations() async throws -> [PersistableWidgetConfiguration] {
        CoreDataPersistenceController.shared.fetchWidgets()
    }
}
