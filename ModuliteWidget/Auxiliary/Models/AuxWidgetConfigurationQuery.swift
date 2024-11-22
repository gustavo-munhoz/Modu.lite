//
//  AuxWidgetConfigurationQuery.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import AppIntents
import WidgetStyling

struct AuxWidgetConfigurationQuery: EntityQuery {
    // TODO: Localize strings
    
    func entities(for identifiers: [UUID]) async throws -> [AuxWidgetConfigurationEntity] {
        let configurations = try await fetchAuxWidgetSchemas(identifiers: identifiers)
        return configurations.map { AuxWidgetConfigurationEntity(id: $0.id, name: $0.name ?? "Unnamed Widget") }
    }

    func suggestedEntities() async throws -> [AuxWidgetConfigurationEntity] {
        let configurations = try await fetchAllAuxWidgetSchemas()
        return configurations.map { AuxWidgetConfigurationEntity(id: $0.id, name: $0.name ?? "Unnamed Widget") }
    }

    func defaultResult() async -> AuxWidgetConfigurationEntity? {
        try? await suggestedEntities().first
    }

    private func fetchAuxWidgetSchemas(identifiers: [UUID]) async throws -> [WidgetSchema] {
        guard IsPlusSubscriberSpecification().isSatisfied() else { return [] }
        
        let predicate = NSPredicate(format: "id IN %@", identifiers.map { $0.uuidString })
        return CoreDataPersistenceController.shared.fetchAuxWidgets(predicate: predicate)
    }
    
    private func fetchAllAuxWidgetSchemas() async throws -> [WidgetSchema] {
        guard IsPlusSubscriberSpecification().isSatisfied() else { return [] }
        
        return CoreDataPersistenceController.shared.fetchAuxWidgets()
    }
}
