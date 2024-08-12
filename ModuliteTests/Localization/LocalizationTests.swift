//
//  LocalizationTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 11/08/24.
//

import XCTest
@testable import Modulite

class LocalizationTests: XCTestCase {
    
    
    func testLocalizedKeyExtraction() {
        let testIntKey = String.LocalizedKey.testInteger(value: 123)
        XCTAssertEqual(testIntKey.key, "testInteger", "The key should correctly extract 'testInteger'.")

        let testNoValueKey = String.LocalizedKey.testNoValue
        XCTAssertEqual(testNoValueKey.key, "testNoValue", "The key should correctly extract 'testNoValue'.")
    }
    
    
    func testLocalizedValuesExtraction() {
        let testIntKey = String.LocalizedKey.testInteger(value: 123)
        XCTAssertEqual(testIntKey.values as? [Int], [123], "The values should correctly extract [123].")
        
//        let testStringKey = String.LocalizedKey.testString(text: "Hello, world!")
//        XCTAssertEqual(testStringKey.values as? [String], "The values should correctly extract [Hello, world!].")
        
        let testArrayKey = String.LocalizedKey.testArray(elements: ["Hello", "World"])
        XCTAssertEqual(testArrayKey.values as? [String], ["Hello", "World"], "The values should correctly extract ['Hello', 'World']")

        let testNoValueKey = String.LocalizedKey.testNoValue
        XCTAssertTrue(testNoValueKey.values.isEmpty, "There should be no values associated with 'example2'.")
    }
    
    
    func testLocalizedMethod() {

        let result1 = String.localized(for: .testInteger(value: 123))
        XCTAssertEqual(result1, "Value: 123", "The localized string should correctly format.")

        let result2 = String.localized(for: .testNoValue)
        XCTAssertEqual(result2, "No values here.", "The localized string should match the key with no values.")
    }
}
