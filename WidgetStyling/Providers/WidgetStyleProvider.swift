//
//  WidgetStyleProvider.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import Foundation

public class WidgetStyleProvider {
    
    // MARK: - Properties
    private(set) var styles: [WidgetStyle] = []
    
    enum ProviderError: Swift.Error {
        case directoryNotFound
    }
    
    // MARK: - Initializer
    public init() throws {
        try loadStyles()
    }
    
    // MARK: - Methods
    private func loadStyles() throws {
        let bundle = Bundle(for: Self.self)
        
        guard let stylesFolderURL = bundle.url(
            forResource: "WidgetStyles",
            withExtension: nil
        ) else {
            throw ProviderError.directoryNotFound
        }
        
        let fileURLs = try FileManager.default.contentsOfDirectory(
            at: stylesFolderURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        
        let jsonFileURLs = fileURLs.filter { $0.pathExtension.lowercased() == "json" }
        
        for fileURL in jsonFileURLs {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let styleData = try decoder.decode(WidgetStyleData.self, from: data)
            let style = try LoadedWidgetStyle(from: styleData)
            
            styles.append(style)
        }
    }
    
    public func getStyle(by identifier: String) -> WidgetStyle? {
        styles.first(where: { $0.identifier == identifier })
    }
    
    public func getAllStyles() -> [WidgetStyle] { styles }
}

