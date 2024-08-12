//
//  DebugOptions.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 11/08/24.
//

/// A custom print function that only runs if the `DEBUG` preprocessor statement is true.
/// This ensures that the print statements are not included in the release builds, optimizing performance and security.
///
/// Usage:
/// ```
/// print("This is a debug message.")
/// print("Multiple", "items", "separated", "by", "spaces")
/// print("Custom separator and terminator", separator: "-", terminator: "!")
/// ```
///
/// - Parameters:
///   - items: Zero or more items to print. The textual representation for each item is the same as that obtained by calling `String(describing:)`.
///   - separator: A string to print between each item. The default is a single space (" ").
///   - terminator: The string to print after all items have been printed. The default is a newline (`"\n"`).
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    #endif
}
