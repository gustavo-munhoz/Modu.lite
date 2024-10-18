//
//  Date+Operations.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 17/10/24.
//

import Foundation

extension Date {
    static var today: Date {
        Calendar.current.startOfDay(for: .now)
    }
    
    static var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    }
    
    func subtractingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: self)!
    }
    
    func subtractOneDay() -> Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func addOneDay() -> Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}
