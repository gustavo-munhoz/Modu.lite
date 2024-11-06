//
//  WidgetContentBuilder.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import Foundation

public class WidgetContentBuilder: Builder {
    
    // MARK: - Properties
    let type: WidgetType
    
    private var name: String?
    private var style: WidgetStyle?
    private var apps: [AppData] = []
    
    enum BuildError: Swift.Error {
        case missingName
        case missingStyle
        case emptyApps
        case appNotFound
        case maxAppsReached
    }
    
    // MARK: - Initializers
    init(type: WidgetType) {
        self.type = type
    }
    
    // MARK: - Getters
    func getCurrentApps() -> [AppData] { apps }
    
    // MARK: - Setters
    func setWidgetName(_ name: String) {
        self.name = name
    }
    
    func setWidgetStyle(_ style: WidgetStyle) {
        self.style = style
    }
    
    func appendApp(_ app: AppData) throws {
        guard apps.count < type.maxModules else { throw BuildError.maxAppsReached }
        
        apps.append(app)
    }
    
    func removeApp(_ app: AppData) throws {
        guard apps.count > 0 else { throw BuildError.emptyApps }
        guard let index = apps.firstIndex(of: app) else { throw BuildError.appNotFound }
        
        apps.remove(at: index)
    }
    
    // MARK: - Build
    func build() throws -> WidgetContent {
        guard let name else { throw BuildError.missingName }
        guard let style else { throw BuildError.missingStyle }
        guard !apps.isEmpty else { throw BuildError.emptyApps }
        
        let emptySpaces = Array(repeating: nil as AppData?, count: type.maxModules - apps.count)
        let appsArray = apps.map { Optional($0) } + emptySpaces

        return WidgetContent(name: name, style: style, apps: appsArray)
    }
}

struct WidgetContent {
    let name: String
    let style: WidgetStyle
    let apps: [AppData?]
}

struct AppData: Equatable, Codable {
    let name: String
    let urlScheme: URL
    let relevance: Int
}