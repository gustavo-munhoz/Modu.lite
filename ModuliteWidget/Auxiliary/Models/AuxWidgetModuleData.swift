//
//  AuxWidgetModuleData.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import SwiftUI

struct AuxWidgetModuleData: Identifiable {
    let id: UUID
    let index: Int
    let image: Image
    let associatedURLScheme: URL?
}
