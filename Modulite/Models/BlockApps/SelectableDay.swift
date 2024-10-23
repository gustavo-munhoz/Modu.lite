//
//  SelectableDay.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/10/24.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

struct SelectableDay {
    let day: WeekDay
    var isSelected: Bool
}

extension Array where Element == SelectableDay {
    static func allWithState(_ selected: Bool) -> [SelectableDay] {
        WeekDay.allCases.map { SelectableDay(day: $0, isSelected: selected) }
    }
}

extension WeekDay {
    var localizedFirstLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
                
        let mondayIndex = 2
        let sundayDate = Calendar.current.date(
            byAdding: .day,
            value: mondayIndex - Calendar.current.component(.weekday, from: Date()),
            to: Date()
        )!
                
        let dayIndex = WeekDay.allCases.firstIndex(of: self) ?? 0
        let referenceDate = Calendar.current.date(
            byAdding: .day,
            value: dayIndex,
            to: sundayDate
        ) ?? sundayDate
        
        let dayName = dateFormatter.string(from: referenceDate)
        return String(dayName.prefix(1))
    }
}
