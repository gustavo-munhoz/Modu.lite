//
//  CoreDataPersistenceController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//

import CoreData
import UIKit

struct CoreDataPersistenceController {
    
    // MARK: - Properties
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
    
    // MARK: - Setup methods
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WidgetData")
        
        guard let appGroupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.dev.mnhz.modu.lite.shared"
        ) else {
            fatalError("Could not find App Group Container")
        }
        
        let storeURL = appGroupURL.appendingPathComponent("WidgetData.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        if inMemory {
            description.url = URL(filePath: "/dev/null")
        }
        
        container.persistentStoreDescriptions = [description]
        
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
    
    func executeInitialSetup() {
        let apps = fetchApps()
        
        if apps.isEmpty {
            populateAppsAtFirstExecution()
        }
    }
}

// MARK: - AppInfo
extension CoreDataPersistenceController {
    
    func fetchApps() -> [AppInfo] {
        let request = AppInfo.nameSortedFetchRequest()
        do {
            let apps = try container.viewContext.fetch(request)
            return apps
            
        } catch {
            print("Error fetching apps: \(error.localizedDescription)")
            return []
        }
    }
    
    private func populateAppsAtFirstExecution() {
        guard let url = Bundle.main.url(forResource: "apps", withExtension: "json") else {
            fatalError("Failed to find apps.json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let appsData = try JSONDecoder().decode([AppInfoData].self, from: data)
            
            appsData.forEach { data in
                AppInfo.createFromData(data, using: container.viewContext)
            }
            
            print("Populated apps with \(appsData.count) items.")
        } catch {
            print("Failed to populate appInfo table with error \(error.localizedDescription)")
        }
    }
}

// MARK: - Widget persistence
extension CoreDataPersistenceController {
    
    func fetchWidgets() -> [PersistableWidgetConfiguration] {
        let request = PersistableWidgetConfiguration.basicFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try container.viewContext.fetch(request)
            
        } catch {
            print("Error fetching widgets: \(error.localizedDescription)")
            return []
        }
    }
    
    @discardableResult
    func registerWidget(
        _ config: ModuliteWidgetConfiguration,
        widgetImage: UIImage
    ) -> PersistableWidgetConfiguration {
        let widgetConfig = PersistableWidgetConfiguration.createFromWidgetConfiguration(
            config,
            widgetImage: widgetImage,
            using: container.viewContext
        )
        
        widgetConfig.createdAt = .now
        
        return widgetConfig
    }
}
