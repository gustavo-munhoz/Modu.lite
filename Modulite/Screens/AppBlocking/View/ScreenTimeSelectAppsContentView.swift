//
//  ScreenTimeSelectAppsContentView.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import Foundation
import SwiftUI
import FamilyControls

struct ScreenTimeSelectAppsContentView: View {
    @State private var pickerIsPresented = false
    @StateObject var session: AppBlockingSession
    var onComplete: ((FamilyActivitySelection) -> Void)?
    var onCancel: (() -> Void)?

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    FamilyActivityPicker(selection: $session.activitySelection)
                        .padding()
                }
                .navigationBarTitle("Select Apps", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        onCancel?()
                    },
                    trailing: Button("Save") {
                        onComplete?(session.activitySelection)
                    }
                )
            }
        }
    }
}
