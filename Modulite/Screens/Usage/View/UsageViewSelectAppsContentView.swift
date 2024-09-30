//
//  UsageViewSelectAppsContentView.swift
//  Modulite
//
//  Created by André Wozniack on 26/09/24.
//

import Foundation
import SwiftUI
import FamilyControls

struct ScreenTimeSelectAppsContentView: View {
    @State private var pickerIsPresented = false
    @ObservedObject var model: ScreenTimeSelectAppsModel

    var body: some View {
        Button {
            pickerIsPresented = true
        } label: {
            Text("Select Apps")
        }
        .familyActivityPicker(
            isPresented: $pickerIsPresented,
            selection: $model.activitySelection
        )
    }
}

class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()
}
