//
//  AppData+Extensions.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/11/24.
//

import WidgetStyling

extension AppData {
    init(persisted: PersistentAppData) {
        self.init(
            name: persisted.name,
            urlScheme: persisted.urlScheme,
            relevance: Int(persisted.relevance)
        )
    }
}
