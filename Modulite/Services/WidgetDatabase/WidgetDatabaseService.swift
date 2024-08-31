//
//  WidgetDatabaseService.swift
//  Modulite
//
//  Created by André Wozniack on 27/08/24.
//

import Foundation
 
protocol WidgetDatabaseService {
    func fetchAllWidgets() -> [WidgetPersistableConfiguration]
    func saveWidget(configuration: WidgetPersistableConfiguration)
    func fetchWidget(with id: UUID) -> WidgetPersistableConfiguration?
    func deleteWidget(with id: UUID)
}
