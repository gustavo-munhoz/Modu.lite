//
//  SwiftDataDatabaseAdapter.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 26/08/24.
//

import UIKit
import SwiftData

class SwiftDataAppInfoDatabaseAdapter: AppInfoDatabaseService {
    // MARK: - Properties
    
    var container: ModelContainer?
    var context: ModelContext?
    
    // MARK: - Lifecycle
    init() {
        do {
            container = try ModelContainer(for: AppInfo.self)
            if let container = self.container {
                context = ModelContext(container)
            }
        } catch {
            print("Error")
        }
    }
    
    private func populateAtFirstExecution(with context: ModelContext) -> [AppInfo] {
        guard let url = Bundle.main.url(forResource: "apps", withExtension: "json") else {
            fatalError("Failed to find apps.json")
        }
        do {
            let data = try Data(contentsOf: url)
            let apps = try JSONDecoder().decode([AppInfo].self, from: data)
            
            for app in apps {
                context.insert(app)
            }
            
            print("\(apps.count) registered in database.")
            return apps
            
        } catch {
            print("Failed to populate apps database with error \(error.localizedDescription).")
            return []
        }
    }
    
    // MARK: - Methods
    
    func fetchApps() -> [AppInfo] {
        guard let context = context else { return [] }
        let sortDescriptor = SortDescriptor<AppInfo>(\.name)
        let descriptor = FetchDescriptor<AppInfo>(sortBy: [sortDescriptor])
        
        do {
            let apps = try context.fetch(descriptor)
            
            guard apps.isEmpty else { return apps }
            
            let savedApps = self.populateAtFirstExecution(with: context)
            
            return savedApps
            
        } catch {
            print("Error fetching apps: \(error.localizedDescription)")
            return []
        }
    }
}
