//
//  AppInfoDatabaseService.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 26/08/24.
//

import Foundation
import SwiftData
import UIKit

protocol AppInfoDatabaseService {
    func fetchApps() -> [AppInfo]
}
