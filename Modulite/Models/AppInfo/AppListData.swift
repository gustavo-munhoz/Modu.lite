//
//  AppListData.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

import Foundation
import WidgetStyling

struct AppListData: Codable {
    let version: Int
    let apps: [AppData]
}
