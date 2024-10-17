//
//  ScreenTimeSelectAppsModel.swift
//  Modulite
//
//  Created by André Wozniack on 16/10/24.
//

import FamilyControls
import SwiftUI

class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()

    init() { }
}
