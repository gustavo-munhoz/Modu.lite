//
//  AppInfo+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//

import CoreData

//extension AppInfo {
//    @NSManaged var name: String
//    @NSManaged var urlScheme: URL
//    @NSManaged var relevance: UInt16
//}
//
//extension AppInfo {
//    static func createFromData(
//        _ data: AppInfoData,
//        using managedObjectContext: NSManagedObjectContext
//    ) {
//        let app = AppInfo(context: managedObjectContext)
//        app.name = data.name
//        app.urlScheme = data.urlScheme
//        app.relevance = UInt16(data.relevance)
//        
//        do {
//            try managedObjectContext.save()
//            
//        } catch {
//            fatalError("Error saving AppInfo: \(error.localizedDescription)")
//        }
//    }
//}
//
//extension AppInfo {
//    static func nameSortedFetchRequest() -> NSFetchRequest<AppInfo> {
//        guard let request = AppInfo.fetchRequest() as? NSFetchRequest<AppInfo> else {
//            fatalError("Could not create AppInfo fetch request.")
//        }
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        return request
//    }
//}
//
//extension AppInfo {
//    static func prioritySortedFetchRequest() -> NSFetchRequest<AppInfo> {
//        guard let request = AppInfo.fetchRequest() as? NSFetchRequest<AppInfo> else {
//            fatalError("Could not create AppInfo fetch request.")
//        }
//        
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "relevance", ascending: true),
//            NSSortDescriptor(key: "name", ascending: true)
//        ]
//        
//        return request
//    }
//}
