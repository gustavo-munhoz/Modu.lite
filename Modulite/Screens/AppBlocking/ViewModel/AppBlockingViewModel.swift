//
//  AppBlockingViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import Foundation

class AppBlockingViewModel {
    
    @Published var activeSessions: [AppBlockingSession] = [
        .init(sessionName: "My session")
    ]
    
    @Published var inactiveSessions: [AppBlockingSession] = [
        .init(sessionName: "Other session"),
        .init(sessionName: "Other session"),
        .init(sessionName: "Other session"),
        .init(sessionName: "Other session")
    ]
}
