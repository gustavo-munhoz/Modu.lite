//
//  String+LocalizedKey.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import Foundation

extension String {
    
    /// Represents keys for localized strings in the app, allowing for dynamic localization with associated values.
    enum LocalizedKey {
        // MARK: - Computed Properties
        
        /// Computes the key for localization by extracting the case name from the enum instance.
        /// Uses reflection to find the label of the first child of the enum case, which represents the case name without associated values.
        /// Falls back to the default description if no label is found.
        fileprivate var key: String {
            if let nameRemovingValues = Mirror(reflecting: self).children.first?.label {
                return nameRemovingValues
            }
            
            return String(describing: self)
        }
        
        /// Computes an array of `CVarArg` suitable for string formatting, reflecting the associated values of the enum case.
        /// Uses reflection to access and cast the associated values to `CVarArg` for use in formatted strings.
        fileprivate var values: [CVarArg] {
            guard let associatedValue = Mirror(reflecting: self).children.first?.value else { return [] }
            
            return Mirror(reflecting: associatedValue).children.compactMap { $0.value as? CVarArg }
        }

        
        // MARK: - Localized Keys
        case <#code#>
    }
    
    /// Returns a localized string using the key and associated values defined by the `LocalizedKey` enum.
    /// Utilizes the `NSLocalizedString` function to fetch the appropriate translation for the key,
    /// and formats it with any associated values using `String(format:arguments:)`.
    /// - Parameter key: The `LocalizedKey` enum case representing the localization key and its associated values.
    /// - Returns: A formatted, localized string.
    static func localized(for key: LocalizedKey) -> String {
        String(format: NSLocalizedString(key.key, comment: ""), arguments: key.values)
    }
}
