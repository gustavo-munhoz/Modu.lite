//
//  String+LocalizedKey.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import Foundation

// swiftlint:disable:next blanket_disable_command
// swiftlint:disable identifier_name

protocol LocalizedKeyProtocol {
    var key: String { get }
    var values: [CVarArg] { get }
}

extension LocalizedKeyProtocol {
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
    static func localized(for key: LocalizedKeyProtocol) -> String {
        String(format: NSLocalizedString(key.key, comment: ""), arguments: key.values)
    }
}

extension String {
    
    /// Represents keys for localized strings in the app, allowing for dynamic localization with associated values.
    /// The cases should be 1-1 with `Localizable.xcstrings` keys.
    public enum LocalizedKey: LocalizedKeyProtocol {
        // MARK: - Computed Properties
        
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
        /// This case is particularly useful for testing localized strings that 
        /// incorporate multiple elements from an array.
        /// - Parameter elements: An array of strings to be localized within test scenarios.
        case testArray(elements: [String])
        
        /// `testTwoStrings` is a test-exclusive enum case used to test functionalities
        ///  that require two separate string inputs.
        /// This case is designed to facilitate testing scenarios where two distinct string 
        /// values need to be validated or processed together.
        /// For example, it could be used to test concatenation, comparison, 
        /// or any function that manipulates two strings.
        /// - Parameters:
        ///   - first: The first string used for testing. This could represent data 
        ///   like a user's first name, an email, or any textual input.
        ///   - second: The second string used for testing. This could represent additional 
        ///   data like a user's last name, a confirmation of the email, or another textual input.
        case testTwoStrings(first: String, second: String)
        
        /// `testNoValue` is a test-exclusive case that represents scenarios 
        /// where no additional values are needed.
        /// This case is used to test the localization process where the localized 
        /// string does not require any dynamic values.
        case testNoValue
        
        // MARK: - Localized Keys -
        
        // MARK: - Reusable texts
        case ok
        case next
        case save
        case cancel
        case delete
        case back
        case plus
        case free
        case guest
        case gotIt
        case unknownErrorOcurred
        case comingSoonTitle
        case comingSoonMessageSingular(feature: String)
        case comingSoonMessagePlural(feature: String)
        
        case tutorialVideos
        
        // MARK: - Tab Bar Titles
        case homeViewControllerTabBarItemTitle
        case usageViewControllerTabBarItemTitle
        case blockAppsViewControllerTabBarItemTitle
        case settingsViewControllerTabBarItemTitle
        
        // MARK: - HomeView & HomeViewController
        case homeViewMainSectionHeaderTitle
        case homeViewAuxiliarySectionHeaderTitle
        case homeViewTipsSectionHeaderTitle
        case homeViewWidgetContextMenuEditTitle
        case homeViewWidgetContextMenuDeleteTitle
        case homeViewDeleteWidgetAlertTitle(widgetName: String)
        case homeViewDeleteWidgetAlertMessage
        case homeViewMainWidgetsPlaceholderTitle
        case homeViewMainWidgetsPlaceholderSubtitle1
        case homeViewMainWidgetsPlaceholderSubtitle2
        case homeViewAuxiliaryWidgetsPlaceholderTitle
        
        case homeViewMainWidgetsDidReachMaxCountAlertTitle
        case homeViewMainWidgetsDidReachMaxCountAlertMessage
        
        // MARK: - WidgetSetupView & WidgetSetupViewController
        case widgetSetupViewMainWidgetNamePlaceholder(number: Int)
        case widgetSetupViewAuxWidgetNamePlaceholder(number: Int)
        case widgetSetupViewStyleHeaderTitle
        case widgetSetupViewAppsHeaderTitle(maxApps: Int)
        case widgetSetupViewSearchAppsButtonTitle
        case widgetSetupViewSearchAppsHelperText
        
        case widgetEditingNavigationTitle
        
        // MARK: - SearchAppsView
        case selectAppsViewTitle
        case selectAppsViewSubtitle
        case selectAppsViewAppsSelected(count: Int, max: Int)
        case selectAppsViewSearchBarPlaceholder
        
        // MARK: - WidgetEditorView & WidgetEditorViewController
        case widgetEditorViewWidgetLayoutTitle
        case widgetEditorViewWidgetModuleStyleTitle
        case widgetEditorViewWidgetWallpaperTitle
        case widgetEditorViewWallpaperButton
        case widgetEditorViewWallpaperButtonSaved
        case widgetEditorViewSaveWidgetButton
        case widgetEditorViewDeleteAlertTitle
        case widgetEditorViewDeleteAlertMessage
        
        case widgetEditingUnsavedChangesAlertTitle
        case widgetEditingUnsavedChangesAlertMessage
        case widgetCreatingUnsavedChangesAlertMessage
        case widgetEditingUnsavedChangesAlertActionDiscard
        case widgetEditingUnsavedChangesAlertActionKeepEditing
        
        // MARK: - UsageView & UsageViewController
        case usageViewYouHaveSpent
        case usageViewOnPhone
        case usageViewControllerNavigationTitle
        case usageViewComparisonOverview
        case usageDailyAvarageYesterday
        case usageDailyAvarageLastWeek
        case usageHowSpentYourTime
        
        // MARK: - BlockAppsView & BlockAppsViewController
        case blockAppsViewBlockingSession(number: Int)
        case appBlockingViewControllerNavigationTitle
        case appBlockingViewControllerActiveTitle
        case appBlockingViewControllerInactiveTitle
        
        // MARK: - CreateBlockingSessionView
        case createBlockingSessionName
        case createBlockingSessionChooseApps
        case createBlockingSessionSearchApps
        case createBlockingSessionSelectedCount(number: Int)
        case createBlockingSessionSelectConditions
        case createBlockingSessionScheduled
        case createBlockingSessionAlwaysOn
        case createBlockingSessionAllDay
        case createBlockingSessionStartAt
        case createBlockingSessionFinishesAt
        case createBlockingSessionDaysOfWeek
        case createBlockingSessionSaveSession
        
        // MARK: - Widget Styles
        case widgetStyleNameAnalog
        case widgetStyleNameTapedeck
        case widgetStyleNameRetromac
        case widgetStyleNameRetromacGreen
        case widgetStyleModutouch3
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
