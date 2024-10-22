//
//  ScreenTimeSelectAppsContentViewDelegate.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//


//
//  ScreenTimeSelectAppsContentView.swift
//  Modulite
//
//  Created by André Wozniack on 26/09/24.
//

import Foundation
import SwiftUI
import FamilyControls

protocol ScreenTimeSelectAppsContentViewDelegate: AnyObject {
    func screenTimeSelectAppsContentView(
        _ view: ScreenTimeSelectAppsContentView,
        didSelect activitySelection: FamilyActivitySelection
    )
}

struct ScreenTimeSelectAppsContentView: View {
    @State private var pickerIsPresented = false
    @StateObject var model: AppBlockingSession
    var onComplete: (() -> Void)?
    var onCancel: (() -> Void)?
    
    weak var delegate: ScreenTimeSelectAppsContentViewDelegate?

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    FamilyActivityPicker(selection: $model.activitySelection)
                        .padding()
                }
                .navigationBarTitle("Select Apps", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        onCancel?()
                    },
                    trailing: Button("Save") {
                        delegate?.screenTimeSelectAppsContentView(
                            self,
                            didSelect: model.activitySelection
                        )
                        onComplete?()
                    }
                )
            }
        }
    }
}
