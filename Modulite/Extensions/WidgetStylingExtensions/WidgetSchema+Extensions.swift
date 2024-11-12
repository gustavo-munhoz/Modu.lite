//
//  WidgetSchema+Extensions.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/11/24.
//

import WidgetStyling
import UIKit

extension WidgetSchema {
    convenience init?(persisted: PersistentWidgetSchema) {
        let provider = try? WidgetStyleProvider()
                
        guard let type = WidgetType(rawValue: persisted.type) else {
            print("Unable to create WidgetType from rawValue: \(persisted.type).")
            return nil
        }
        
        guard let moduleArray = persisted.modules.allObjects as? [PersistentWidgetModule] else {
            print("Unable to convert NSArray to [PersistentWidgetModule].")
            return nil
        }
        
        guard let style = provider?.getStyle(by: persisted.styleIdentifier) else {
            print("Unable to get style with identifier \(persisted.styleIdentifier).")
            return nil
        }
        
        guard let modules = moduleArray.map({ WidgetModule(persisted: $0) }) as? [WidgetModule] else {
            print("Unable to convert [PersistentWidgetModule] to [WidgetModule].")
            return nil
        }
        
        self.init(
            type: type,
            style: style,
            name: persisted.name,
            modules: modules,
            lastEditedAt: persisted.lastEditedAt
        )
    }
}