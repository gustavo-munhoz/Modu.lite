//
//  StringExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import XCTest
@testable import Modulite

class StringExtensionsTests: XCTestCase {
    
    func testCamelCasedMultipleWords() {
        let input = "this is a test"
        let expectedOutput = "thisIsATest"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedWithSpecialCharacters() {
        let input = "this_is-a.test"
        let expectedOutput = "thisIsATest"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedAlreadyCamelCase() {
        let input = "alreadyCamelCase"
        let expectedOutput = "alreadyCamelCase"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedEmptyString() {
        let input = ""
        let expectedOutput = ""
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedSingleWord() {
        let input = "word"
        let expectedOutput = "word"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedWithNonAlphanumericCharacters() {
        let input = "hello!@#world"
        let expectedOutput = "helloWorld"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedWithLeadingAndTrailingSpaces() {
        let input = "  leading and trailing spaces  "
        let expectedOutput = "leadingAndTrailingSpaces"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedWithUppercaseInput() {
        let input = "THIS IS UPPERCASE"
        let expectedOutput = "thisIsUppercase"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
    
    func testCamelCasedWithMixedCaseInput() {
        let input = "tHis Is a MiXeD CaSe"
        let expectedOutput = "thisIsAMixedCase"
        XCTAssertEqual(input.camelCased(), expectedOutput)
    }
}
