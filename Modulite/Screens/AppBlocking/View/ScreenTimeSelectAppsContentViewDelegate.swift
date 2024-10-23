//
//  ScreenTimeSelectAppsContentViewDelegate.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import SwiftUI
import FamilyControls

protocol ScreenTimeSelectAppsContentViewDelegate: AnyObject {
    func screenTimeSelectAppsContentView(
        _ view: ScreenTimeSelectAppsContentView,
        didSelect activitySelection: FamilyActivitySelection
    )
}

struct ScreenTimeSelectAppsContentView: View {
    @StateObject var model: AppBlockingSession
    weak var delegate: ScreenTimeSelectAppsContentViewDelegate?
    
    var body: some View {
        NavigationStack {
            VStack {
                FamilyActivityPicker(selection: $model.activitySelection)
                    .padding()
            }
            .navigationTitle("Select Apps")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        delegate?.screenTimeSelectAppsContentView(self, didSelect: model.activitySelection)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        delegate?.screenTimeSelectAppsContentView(self, didSelect: model.activitySelection)
                    }
                }
            }
        }
    }
}
