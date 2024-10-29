//
//  AppsData.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

import Foundation

struct AppsData: Codable {
    let version: Int
    let apps: [AppInfoData]
}
