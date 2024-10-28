//
//  AppBlockingViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import Foundation

class AppBlockingViewModel {
    
    // MARK: - Properties
    
    // TODO: Fetch persisted sessions
    @Published var activeSessions: [AppBlockingSession] = [
        .init(sessionName: "My session", isActive: true)
    ]
    
    @Published var inactiveSessions: [AppBlockingSession] = [
        .init(sessionName: "Other session 1"),
        .init(sessionName: "Other session 2"),
        .init(sessionName: "Other session 3"),
        .init(sessionName: "Other session 4")
    ]
    
    // MARK: - Actions
    func updateState(of session: AppBlockingSession, to isActive: Bool) {
        session.lastTimeToggled = .now
        session.isActive = isActive
        
        activeSessions.removeAll { $0 == session }
        inactiveSessions.removeAll { $0 == session }
        
        if session.isActive {
            activeSessions.append(session)
        } else {
            inactiveSessions.append(session)
        }
    }
    
    func sortSessions() {
        activeSessions = activeSessions.sortedByLastToggled()
        inactiveSessions = inactiveSessions.sortedByLastToggled()
    }
}

extension Array where Element: AppBlockingSession {
    func sortedByLastToggled() -> [Element] {
        sorted(by: { $0.lastTimeToggled > $1.lastTimeToggled })
    }
}
