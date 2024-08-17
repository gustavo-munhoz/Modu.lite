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
        
        let testStringKey = String.LocalizedKey.testString(text: "Hello")
        XCTAssertEqual(testStringKey.key, "testString", "The key should correctly extract 'testString'.")
        
        let testArrayKey = String.LocalizedKey.testArray(elements: ["Hello", "World"])
        XCTAssertEqual(testArrayKey.key, "testArray", "The key should correctly extract 'testArray'.")
        
        let testTwoStringsKey = String.LocalizedKey.testTwoStrings(first: "Hello", second: "World")
        XCTAssertEqual(testTwoStringsKey.key, "testTwoStrings", "The key should correctly extract 'testTwoStrings'.")
        
        let testNoValueKey = String.LocalizedKey.testNoValue
        XCTAssertEqual(testNoValueKey.key, "testNoValue", "The key should correctly extract 'testNoValue'.")
    }
    
    func testLocalizedValuesExtraction() {
        let testIntKey = String.LocalizedKey.testInteger(value: 123)
        XCTAssertEqual(testIntKey.values as? [Int], [123], "The values should correctly extract [123].")
        
        let testStringKey = String.LocalizedKey.testString(text: "Hello, world!")
        XCTAssertEqual(
            testStringKey.values as? [String],
            ["Hello, world!"],
            "The values should correctly extract ['Hello, world!']."
        )
        
        let testArrayKey = String.LocalizedKey.testArray(elements: ["Hello", "World"])
        XCTAssertEqual(
            testArrayKey.values as? [String],
            ["Hello", "World"],
            "The values should correctly extract ['Hello', 'World']"
        )
        
        let testTwoStringsKey = String.LocalizedKey.testTwoStrings(first: "Hello", second: "World")
        XCTAssertEqual(
            testTwoStringsKey.values as? [String],
            ["Hello", "World"],
            "The values should correctly extract ['Hello', 'World']"
        )
        
        let testNoValueKey = String.LocalizedKey.testNoValue
        XCTAssertTrue(testNoValueKey.values.isEmpty, "There should be no values associated with 'testNoValue'.")
    }
    
    func testLocalizedMethod() {

        let intResult = String.localized(for: .testInteger(value: 123))
        XCTAssertEqual(intResult, "Value: 123", "The localized string should correctly format.")

        let strResult = String.localized(for: .testString(text: "Test string"))
        XCTAssertEqual(strResult, "String: Test string", "The localized string should correctly format.")
        
        let arrayResult = String.localized(for: .testArray(elements: ["String 1", "String 2"]))
        XCTAssertEqual(arrayResult, "Strings: String 1, String 2", "The localized string should correctly format.")
        
        let twoStringsResult = String.localized(for: .testTwoStrings(first: "Hello", second: "World"))
        XCTAssertEqual(twoStringsResult, "Hello, World!", "The localized string should correctly format.")
        
        let noneResult = String.localized(for: .testNoValue)
        XCTAssertEqual(noneResult, "No values here.", "The localized string should match the key with no values.")
    }
}
