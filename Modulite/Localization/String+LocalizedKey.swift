//
//  String+LocalizedKey.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import Foundation

extension String {
    
    /// Represents keys for localized strings in the app, allowing for dynamic localization with associated values.
    public enum LocalizedKey {
        // MARK: - Computed Properties
        
        /// Computes the key for localization by extracting the case name from the enum instance.
        /// Uses reflection to find the label of the first child of the enum case, which represents the case name without associated values.
        /// Falls back to the default description if no label is found.
         var key: String {
            if let nameRemovingValues = Mirror(reflecting: self).children.first?.label {
                return nameRemovingValues
            }
            
            return String(describing: self)
        }
        
        /// Computes an array of `CVarArg` suitable for string formatting, reflecting the associated values of the enum case.
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

        // MARK: - Test cases
        /// `testInteger` is a test-exclusive case designed to be used in unit testing environments.
        /// This case holds an integer value used for testing localized string handling.
        /// - Parameter value: An integer to be localized within test scenarios.
        case testInteger(value: Int)
        
        /// `testString` is a test-exclusive case designed for testing the localization of strings.
        /// This case allows for the inclusion of a string to be used in localized outputs during tests.
        /// - Parameter text: A string that is intended to test string localization.
        case testString(text: String)
        
        /// `testArray` is a test-exclusive case used to test the localization of array elements.
        /// This case is particularly useful for testing localized strings that incorporate multiple elements from an array.
        /// - Parameter elements: An array of strings to be localized within test scenarios.
        case testArray(elements: [String])
        
        case testTwoStrings(first: String, second: String)
        
        /// `testNoValue` is a test-exclusive case that represents scenarios where no additional values are needed.
        /// This case is used to test the localization process where the localized string does not require any dynamic values.
        case testNoValue
        
        // MARK: - Localized Keys
        
        
    }
    
    /// Returns a localized string using the key and associated values defined by the `LocalizedKey` enum.
    /// Utilizes the `NSLocalizedString` function to fetch the appropriate translation for the key,
    /// and formats it with any associated values using `String(format:arguments:)`.
    /// - Parameter key: The `LocalizedKey` enum case representing the localization key and its associated values.
    /// - Returns: A formatted, localized string.
    static public func localized(for key: LocalizedKey) -> String {
        String(format: NSLocalizedString(key.key, comment: ""), arguments: key.values)
    }
}
