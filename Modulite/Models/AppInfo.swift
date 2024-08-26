//
//  AppInfo.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 26/08/24.
//

import Foundation
import SwiftData

@Model
class AppInfo: Codable {
    var name: String
    var urlScheme: String
    
    private enum CodingKeys: CodingKey {
        case name, urlScheme
    }
    
    init(name: String, urlScheme: String) {
        self.name = name
        self.urlScheme = urlScheme
    }
    
    // MARK: - Codable
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.urlScheme = try container.decode(String.self, forKey: .urlScheme)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(urlScheme, forKey: .urlScheme)
    }
}
