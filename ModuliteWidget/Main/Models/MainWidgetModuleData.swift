//
//  MainWidgetModuleData.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/09/24.
//

import Foundation
import SwiftUI

struct MainWidgetModuleData: Identifiable {
    let id: UUID
    let index: Int
    let image: Image
    let associatedURLScheme: URL?
}
