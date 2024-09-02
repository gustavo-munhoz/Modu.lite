//
//  PersistableModuleConfiguration+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//

import UIKit
import CoreData

extension PersistableModuleConfiguration {
    @NSManaged var appName: String
    @NSManaged var urlScheme: URL
    @NSManaged var selectedStyleKey: String
    @NSManaged var selectedColor: UIColor
    @NSManaged var resultingImageURL: URL
}
