//
//  BlockAppsViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 30/09/24.
//

import Foundation

class BlockAppsViewModel {
    init() {
        // fetchBlockingSessions
    }
    
    // MARK: - Getters
    
    // MARK: - Setters
    
}

enum BlockingType {
    case scheduled
    case alwaysOn
}

class AppBlockingSession {
    var id: String! // bundle id do app
    var appsToBlock: [String] = [] // apps para bloquear
    var blockingType: BlockingType!
    var isAllDay: Bool!
    var startsAt: Date?
    var endsAt: Date?
    var daysOfWeek: [Int]?
}

class AppBlockingSessionBuilder {
    var id: String! // bundle id do app
    var appsToBlock: [String] = [] // apps para bloquear
    var blockingType: BlockingType!
    var isAllDay: Bool!
    var startsAt: Date?
    var endsAt: Date?
    var daysOfWeek: [Int]?
    
    private var session = AppBlockingSession()
    
    // MARK: - Getters
    
    // MARK: - Setters
    func setAppsToBlock(_ apps: [String]) {
        appsToBlock = apps
    }
    
    func blockingType(_ type: BlockingType) {
        blockingType = type
    }
    
//    func build() -> AppBlockingSession {
//        return ...
//    }
}
