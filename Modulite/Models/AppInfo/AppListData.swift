//
//  AppListData.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

import Foundation

struct AppListData: Codable {
    let version: Int
    let apps: [AppInfoData]
}
