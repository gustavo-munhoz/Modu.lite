//
//  PersistentAppData+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/11/24.
//

import CoreData
import WidgetStyling

extension PersistentAppData {
    @NSManaged var name: String
    @NSManaged var urlScheme: URL
    @NSManaged var relevance: UInt16
}

extension PersistentAppData {
    static func from(
        data: AppData,
        using managedObjectContext: NSManagedObjectContext
    ) {
        let app = PersistentAppData(context: managedObjectContext)
        
        app.name = data.name
        app.urlScheme = data.urlScheme
        app.relevance = UInt16(data.relevance)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving app data: \(error.localizedDescription)")
        }
    }
}

extension PersistentAppData {
    static func nameSortedFetchRequest() -> NSFetchRequest<PersistentAppData> {
        guard let request = PersistentAppData.fetchRequest() as? NSFetchRequest<PersistentAppData> else {
            fatalError("Could not create fetch request for PersistentAppData.")
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
}

extension PersistentAppData {
    static func prioritySortedFetchRequest() -> NSFetchRequest<PersistentAppData> {
        guard let request = PersistentAppData.fetchRequest() as? NSFetchRequest<PersistentAppData> else {
            fatalError("Could not create fetch request for PersistentAppData.")
        }
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "relevance", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return request
    }
}
