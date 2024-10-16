//
//  TimeInterval+ToHoursAndMinutes.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 15/10/24.
//

import Foundation

extension TimeInterval {
    func toHoursAndMinutes() -> String {
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d", hours, minutes)
    }
    
    func formattedWithUnits() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        formatter.collapsesLargestUnit = false
        formatter.maximumUnitCount = 2
        
        guard let formattedString = formatter.string(from: self) else {
            return "0 min"
        }
                
        let components = formattedString.split(separator: ",")
        let spacedComponents = components.map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: " ")
        
        return spacedComponents
    }
}
