//
//  CoreDataPersistenceController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//

import CoreData
import UIKit
import WidgetStyling

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
        
        guard let appGroupID = Bundle.main.object(forInfoDictionaryKey: "AppGroupID") as? String else {
            fatalError("Could not find App Group ID in Info.plist")
        }
        
        guard let appGroupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
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
        resetAllDataIfNeeded(databaseVersion: 1)
        checkVersionAndPopulateIfNeeded()
    }
    
    private func resetAllDataIfNeeded(databaseVersion version: Int) {
        let hasResetKey = "hasResetDataAtVersion\(version)"
        guard !UserDefaults.standard.bool(forKey: hasResetKey) else { return }
        
        container.performBackgroundTask { context in
            let entityNames = Array(container.managedObjectModel.entitiesByName.keys)
            for entityName in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try context.execute(batchDeleteRequest)
                } catch {
                    print("Failed to batch delete entity \(entityName): \(error)")
                }
            }

            do {
                try context.save()
            } catch {
                print("Failed to save context after batch deletes: \(error)")
            }
        }
        
        FileManagerImagePersistenceController.shared.deleteAllWidgetImages()

        UserDefaults.standard.set(true, forKey: hasResetKey)
        UserDefaults.standard.removeObject(forKey: "appsDataVersion")

        print("All data successfully cleared")
    }
}

// MARK: - AppInfo
extension CoreDataPersistenceController {
    
    func fetchApps(predicate: NSPredicate? = nil) -> [AppData] {
        let request = PersistentAppData.prioritySortedFetchRequest()
        request.predicate = predicate
        do {
            let persistedApps = try container.viewContext.fetch(request)
            
            let apps = persistedApps.compactMap { AppData(persisted: $0) }
            
            return apps
            
        } catch {
            print("Error fetching apps: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAppData(named name: String, urlScheme: String) -> AppData? {
        let predicate = NSPredicate(format: "name == %@ AND urlScheme == %@", name, urlScheme)
        let apps = CoreDataPersistenceController.shared.fetchApps(predicate: predicate)
        return apps.first
    }
    
    private func checkVersionAndPopulateIfNeeded() {
        guard let url = Bundle.main.url(forResource: "apps", withExtension: "json") else {
            fatalError("Failed to find apps.json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let appsData = try JSONDecoder().decode(AppListData.self, from: data)
                        
            let currentVersion = UserDefaults.standard.integer(forKey: "appsDataVersion")
            
            guard appsData.version > currentVersion else {
                print("App data is already up to date with version \(currentVersion).")
                return
            }
            
            clearOldAppsData()
            
            appsData.apps.forEach { data in
                PersistentAppData.from(data: data, using: container.viewContext)
            }
            
            UserDefaults.standard.set(appsData.version, forKey: "appsDataVersion")
            
            print("Populated apps with \(appsData.apps.count) items.")
            
        } catch {
            print("Failed to populate appInfo table with error \(error.localizedDescription)")
        }
    }
    
    private func clearOldAppsData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PersistentAppData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
            print("Cleared old app data.")
        } catch {
            print("Failed to clear old app data with error \(error.localizedDescription)")
        }
    }
}

// MARK: - Widget persistence
extension CoreDataPersistenceController {
    func fetchMainWidgets(predicate: NSPredicate? = nil) -> [WidgetSchema] {
        let typePredicate = NSPredicate(format: "type == %@", WidgetType.main.rawValue)
        let combinedPredicate = combinePredicates(typePredicate, predicate)
        return fetchWidgets(with: combinedPredicate)
    }

    func fetchAuxWidgets(predicate: NSPredicate? = nil) -> [WidgetSchema] {
        let typePredicate = NSPredicate(format: "type == %@", WidgetType.auxiliary.rawValue)
        let combinedPredicate = combinePredicates(typePredicate, predicate)
        return fetchWidgets(with: combinedPredicate)
    }
    
    private func fetchWidgets(with predicate: NSPredicate?) -> [WidgetSchema] {
        let request = PersistentWidgetSchema.basicFetchRequest()
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "lastEditedAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let persistedWidgets = try container.viewContext.fetch(request)
            let widgetSchemas = persistedWidgets.compactMap { persistedWidget in
                return WidgetSchema(persisted: persistedWidget)
            }
            
            return widgetSchemas
            
        } catch {
            print("Error fetching widgets: \(error.localizedDescription)")
            return []
        }
    }

    private func combinePredicates(
        _ first: NSPredicate,
        _ second: NSPredicate?
    ) -> NSPredicate {
        guard let second else { return first }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [first, second])
    }
    
    func deleteWidget(withId id: UUID) {
        let context = container.viewContext
        let request = PersistentWidgetSchema.basicFetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            guard let widget = try context.fetch(request).first else {
                print("Widget with id \(id) not found.")
                return
            }
            
            context.delete(widget)
            
            try context.save()
            
            FileManagerImagePersistenceController.shared.deleteWidgetAndModules(widgetId: id)
            print("Widget with id \(id) deleted successfully from CoreData.")
            
        } catch {
            print("Error deleting widget from CoreData: \(error.localizedDescription)")
        }
    }
}

extension CoreDataPersistenceController {
    @discardableResult
    func registerOrUpdateWidget(
        _ schema: WidgetSchema,
        widgetImage: UIImage,
        moduleImages: [Int: UIImage]
    ) -> PersistentWidgetSchema {
        let context = container.viewContext
        let fetchRequest = PersistentWidgetSchema.basicFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", schema.id as CVarArg)
        
        do {
            guard let existingWidget = try context.fetch(fetchRequest).first else {
                let newWidget = PersistentWidgetSchema.from(
                    schema: schema,
                    widgetImage: widgetImage,
                    moduleImages: moduleImages,
                    using: context
                )
                
                print("Widget created successfully.")
                
                return newWidget
            }
            
            existingWidget.name = schema.name
            existingWidget.styleIdentifier = schema.widgetStyle.identifier
            
            let widgetImageUrl = FileManagerImagePersistenceController.shared.saveWidgetImage(
                image: widgetImage,
                for: existingWidget.id
            )
            
            existingWidget.previewImageUrl = widgetImageUrl
            
            if let modules = existingWidget.modules as? Set<PersistentWidgetModule> {
                for module in modules {
                    context.delete(module)
                }
            }

            let newModules = createPersistentModules(
                schema: schema,
                modules: schema.modules,
                moduleImages: moduleImages,
                context: context
            )
            
            existingWidget.modules = newModules as NSSet
            existingWidget.lastEditedAt = .now
            
            try context.save()
            
            print("Widget \(existingWidget.id) updated successfully.")
            return existingWidget
            
        } catch {
            print("Error registering or updating widget: \(error.localizedDescription)")
            fatalError("Failed to register or update widget.")
        }
    }
    
    private func createPersistentModules(
        schema: WidgetSchema,
        modules: [WidgetModule],
        moduleImages: [Int: UIImage],
        context: NSManagedObjectContext
    ) -> Set<PersistentWidgetModule> {
        Set(
            modules.map {
                guard let image = moduleImages[$0.position] else {
                    fatalError("Fatal error: module image not found")
                }
                
                let imageURL = FileManagerImagePersistenceController.shared.saveModuleImage(
                    image: image,
                    for: schema.id,
                    moduleIndex: $0.position
                )
                
                let persistentModule = PersistentWidgetModule.from(
                    module: $0,
                    imageURL: imageURL,
                    schema: schema,
                    using: context
                )
                
                return persistentModule
            }
        )
    }
}
