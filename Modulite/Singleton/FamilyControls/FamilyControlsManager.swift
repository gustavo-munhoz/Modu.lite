//
//  File.swift
//  Modulite
//
//  Created by André Wozniack on 02/10/24.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

class FamilyControlsManager: ObservableObject {
    static let shared = FamilyControlsManager()
    
    func requestAuthorization() {
        let authCenter = AuthorizationCenter.shared
        Task {
            do {
                try await authCenter.requestAuthorization(for: .individual)
            } catch {
                print("Authorization Error")
            }
        }
    }
}
