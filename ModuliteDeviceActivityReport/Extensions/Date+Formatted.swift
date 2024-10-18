//
//  Date+Formatted.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 16/10/24.
//

import Foundation

extension Date {
    func formattedWithDayAndMonth(locale: Locale = Locale.current) -> String {
        let calendar = Calendar.current
        
        let monthFormatter = DateFormatter()
        monthFormatter.locale = locale
        monthFormatter.setLocalizedDateFormatFromTemplate("MMM")
        var month = monthFormatter.string(from: self)
        if !month.hasSuffix(".") {
            month.append(".")
        }
        
        let day = calendar.component(.day, from: self)
        let dayString = formattedDayWithOrdinal(day: day, locale: locale)
        
        return "\(month) \(dayString)"
    }
    
    func formattedWithOrdinal(locale: Locale = Locale.current) -> String {
        let calendar = Calendar.current
        
        let monthFormatter = DateFormatter()
        monthFormatter.locale = locale
        monthFormatter.setLocalizedDateFormatFromTemplate("MMM")
        var month = monthFormatter.string(from: self)
        if !month.hasSuffix(".") {
            month.append(".")
        }
        
        let day = calendar.component(.day, from: self)
        let dayString = formattedDayWithOrdinal(day: day, locale: locale)
        
        let yearFormatter = DateFormatter()
        yearFormatter.locale = locale
        yearFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        let year = yearFormatter.string(from: self)
        
        return "\(month) \(dayString), \(year)"
    }

    private func formattedDayWithOrdinal(day: Int, locale: Locale) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = locale

        if let dayString = numberFormatter.string(from: NSNumber(value: day)) {
            return dayString
        } else {
            return "\(day)"
        }
    }
}
