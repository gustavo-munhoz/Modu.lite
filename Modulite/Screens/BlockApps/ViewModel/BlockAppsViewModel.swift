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
    var activitySelection: FamilyActivitySelection?
    
    @discardableResult
    func createBlockingSession(_ session: AppBlockingSession) -> Int {
        blockingSessions.append(session)
        return 0
    }
    
}
