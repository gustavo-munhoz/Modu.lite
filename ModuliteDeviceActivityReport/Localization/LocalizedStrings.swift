//
//  LocalizedStrings.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 16/10/24.
//

import Foundation

protocol LocalizedKey {
    var key: String { get }
    var values: [CVarArg] { get }
}

extension LocalizedKey {
    /// Computes the key for localization by extracting the case name from the enum instance.
    /// Uses reflection to find the label of the first child of the enum case,
    /// which represents the case name without associated values.
    /// Falls back to the default description if no label is found.
    var key: String {
       if let nameRemovingValues = Mirror(reflecting: self).children.first?.label {
           return nameRemovingValues
       }
       
       return String(describing: self)
   }
   
   /// Computes an array of `CVarArg` suitable for string formatting,
   /// reflecting the associated values of the enum case.
   /// Uses reflection to access and cast the associated values to `CVarArg` for use in formatted strings.
   var values: [CVarArg] {
       let mirror = Mirror(reflecting: self)
       guard let associated = mirror.children.first?.value else { return [] }
       
       var extractedValues = [CVarArg]()
       let valuesMirror = Mirror(reflecting: associated)
       for child in valuesMirror.children {
           if let array = child.value as? [CVarArg] {
               extractedValues.append(contentsOf: array)
           } else if let value = child.value as? CVarArg {
               extractedValues.append(value)
           }
       }
       
       return extractedValues
   }
}

extension String {
    enum DeviceActivityReportTextKey: LocalizedKey {
        case youHaveSpent
        case onYourPhoneToday
        case comparisonOverview
        case screenTimeYesterday
        case screenTime7DaysAverage
    }
    
    static func localized(for key: DeviceActivityReportTextKey) -> String {
        String(format: NSLocalizedString(key.key, comment: ""), arguments: key.values)
    }
}
