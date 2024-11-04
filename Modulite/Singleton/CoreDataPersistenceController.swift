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
        checkVersionAndPopulateIfNeeded()
    }
}

// MARK: - AppInfo
extension CoreDataPersistenceController {
    
    func fetchApps(predicate: NSPredicate? = nil) -> [AppInfo] {
        let request = AppInfo.prioritySortedFetchRequest()
        request.predicate = predicate
        do {
            let apps = try container.viewContext.fetch(request)
            return apps
        } catch {
            print("Error fetching apps: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAppInfo(named name: String, urlScheme: String) -> AppInfo? {
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
            let appsData = try JSONDecoder().decode(AppsData.self, from: data)
                        
            let currentVersion = UserDefaults.standard.integer(forKey: "appsDataVersion")
            
            guard appsData.version > currentVersion else {
                print("App data is already up to date with version \(currentVersion).")
                return
            }
            
            clearOldAppsData()
            
            appsData.apps.forEach { data in
                AppInfo.createFromData(data, using: container.viewContext)
            }
            
            UserDefaults.standard.set(appsData.version, forKey: "appsDataVersion")
            
            print("Populated apps with \(appsData.apps.count) items.")
            
        } catch {
            print("Failed to populate appInfo table with error \(error.localizedDescription)")
        }
    }
    
    private func clearOldAppsData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AppInfo.fetchRequest()
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
    func fetchWidgets(predicate: NSPredicate? = nil) -> [PersistableWidgetConfiguration] {
        let request = PersistableWidgetConfiguration.basicFetchRequest()
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try container.viewContext.fetch(request)
            
        } catch {
            print("Error fetching widgets: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteWidget(withId id: UUID) {
        let context = container.viewContext
        let request = PersistableWidgetConfiguration.basicFetchRequest()
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
        _ config: ModuliteWidgetConfiguration,
        widgetImage: UIImage
    ) -> PersistableWidgetConfiguration {
        let context = container.viewContext
        let fetchRequest = PersistableWidgetConfiguration.basicFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", config.id as CVarArg)
        
        do {
            guard let existingWidget = try context.fetch(fetchRequest).first else {
                let newWidget = PersistableWidgetConfiguration.createFromWidgetConfiguration(
                    config,
                    widgetImage: widgetImage,
                    using: context
                )
                
                print("Widget created successfully.")
                
                return newWidget
            }
            
            existingWidget.name = config.name
            
            guard let styleKey = config.widgetStyle?.key else {
                fatalError("Unable to get widget style key. Aborting object update.")
            }
            
            existingWidget.widgetStyleKey = styleKey.rawValue
            
            let widgetImageUrl = FileManagerImagePersistenceController.shared.saveWidgetImage(
                image: widgetImage,
                for: existingWidget.id
            )
            existingWidget.previewImageUrl = widgetImageUrl
            
            if let modules = existingWidget.modules as? Set<PersistableModuleConfiguration> {
                for module in modules {
                    context.delete(module)
                }
            }
            
            var newModules: Set<PersistableModuleConfiguration> = []
            for moduleConfig in config.modules {
                guard let moduleImage = moduleConfig.generateWidgetButtonImage() else {
                    fatalError("Could not generate module image")
                }
                
                let persistentModule = PersistableModuleConfiguration.instantiateFromConfiguration(
                    moduleConfig,
                    widgetId: existingWidget.id,
                    moduleImage: moduleImage,
                    using: context
                )
                newModules.insert(persistentModule)
            }
            
            existingWidget.modules = newModules as NSSet
            existingWidget.createdAt = .now
            
            try context.save()
            
            print("Widget \(existingWidget.id) updated successfully.")
            return existingWidget
            
        } catch {
            print("Error registering or updating widget: \(error.localizedDescription)")
            fatalError("Failed to register or update widget.")
        }
    }
}
