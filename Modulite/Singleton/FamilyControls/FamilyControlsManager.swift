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
    
    private let authCenter = AuthorizationCenter.shared
    
    private init() { }
    
    @Published var isAuthorized = false
    
    func requestAuthorization(
        onCompletion: @escaping (Result<Void, Error>) -> Void = { _ in }
    ) {
        Task {
            do {
                try await authCenter.requestAuthorization(for: .individual)
                isAuthorized = true
                
                onCompletion(.success(()))
            } catch {
                print("Authorization Error: \(error.localizedDescription)")
                isAuthorized = false
                
                onCompletion(.failure(error))
            }
        }
    }
}
