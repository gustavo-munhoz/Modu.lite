//
//  UsageViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 27/09/24.
//

import Foundation
import FamilyControls

class UsageViewModel {
    private let authCenter = AuthorizationCenter.shared
    
    func requestAuthorization() async throws {
        try await authCenter.requestAuthorization(for: .individual)
    }
}
