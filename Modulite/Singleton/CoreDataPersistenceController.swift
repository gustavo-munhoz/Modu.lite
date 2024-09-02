//
//  Persistence.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//

import CoreData

struct CoreDataPersistenceController {
    
    static let shared = CoreDataPersistenceController()
    
    static var preview: CoreDataPersistenceController = {
        let result = CoreDataPersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModels")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(filePath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
    }
}
