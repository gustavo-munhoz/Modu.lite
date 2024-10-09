//
//  WeekDay.swift
//  Modulite
//
//  Created by André Wozniack on 03/10/24.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case monday    = 0
    case tuesday   = 1
    case wednesday = 2
    case thursday  = 3
    case friday    = 4
    case saturday  = 5
    case sunday    = 6

    var displayName: String {
        switch self {
        case .sunday:    return "Sunday"
        case .monday:    return "Monday"
        case .tuesday:   return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday:  return "Thursday"
        case .friday:    return "Friday"
        case .saturday:  return "Saturday"
        }
    }
    
    var listName: String {
        switch self {
        case .monday:    return "M"
        case .tuesday:   return "T"
        case .wednesday: return "W"
        case .thursday:  return "T"
        case .friday:    return "F"
        case .saturday:  return "S"
        case .sunday:    return "S"
        }
    }
}
