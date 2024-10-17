//
//  BlockAppsViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 30/09/24.
//

import Foundation
import FamilyControls

class BlockAppsViewModel: ObservableObject {
    @Published var blockingSessions: [AppBlockingSession] = []
    
    func createBlockingSession(_ session: AppBlockingSession) {
        blockingSessions.append(session)
    }
    
    func updateBlockingSession(_ session: AppBlockingSession) {
        if let index = blockingSessions.firstIndex(where: { $0.id == session.id }) {
            blockingSessions[index] = session
        }
    }
}
