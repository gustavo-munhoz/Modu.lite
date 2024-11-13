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
    
    enum ContentError: Swift.Error {
        case missingName
        case missingStyle
        case emptyApps
        case appNotFound
        case maxAppsReached
    }
    
    // MARK: - Initializers
    public init(type: WidgetType) {
        self.type = type
    }
    
    // MARK: - Getters
    public func getWidgetType() -> WidgetType { type }
    public func getCurrentApps() -> [AppData] { apps }
    
    // MARK: - Setters
    public func setWidgetName(_ name: String?) {
        self.name = name
    }
    
    public func setWidgetStyle(_ style: WidgetStyle) {
        self.style = style
    }
    
    public func appendApp(_ app: AppData) throws {
        guard apps.count < type.maxModules else { throw ContentError.maxAppsReached }
        
        apps.append(app)
    }
    
    public func removeApp(_ app: AppData) throws {
        guard apps.count > 0 else { throw ContentError.emptyApps }
        guard let index = apps.firstIndex(of: app) else { throw ContentError.appNotFound }
        
        apps.remove(at: index)
    }
    
    // MARK: - Build
    public func build() throws -> WidgetContent {
        guard let name else { throw ContentError.missingName }
        guard let style else { throw ContentError.missingStyle }
        guard !apps.isEmpty else { throw ContentError.emptyApps }
        
        let emptySpaces = Array(repeating: nil as AppData?, count: type.maxModules - apps.count)
        let appsArray = apps.map { Optional($0) } + emptySpaces

        return WidgetContent(type: type, name: name, style: style, apps: appsArray)
    }
}

public struct WidgetContent {
    public let type: WidgetType
    public let name: String
    public let style: WidgetStyle
    public let apps: [AppData?]
}

public struct AppData: Equatable, Codable {
    public let name: String
    public let urlScheme: URL
    public let relevance: Int
    
    public init(name: String, urlScheme: URL, relevance: Int) {
        self.name = name
        self.urlScheme = urlScheme
        self.relevance = relevance
    }
}
