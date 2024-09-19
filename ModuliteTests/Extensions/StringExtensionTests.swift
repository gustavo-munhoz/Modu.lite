//
//  StringExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import Testing
import UIKit
@testable import Modulite

@Suite("String tests") struct StringExtensionsTests {
    
    @Test("Camel case with multiple words")
    func camelCasedMultipleWords() {
        let input = "this is a test"
        let expectedOutput = "thisIsATest"
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Camel case with special characters")
    func camelCasedWithSpecialCharacters() {
        let input = "this_is-a.test"
        let expectedOutput = "thisIsATest"
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Camel case with already camel cased text")
    func camelCasedAlreadyCamelCase() {
        let input = "alreadyCamelCase"
        let expectedOutput = "alreadyCamelCase"
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Camel case with empty string")
    func camelCasedEmptyString() {
        let input = ""
        let expectedOutput = ""
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Caml case with single word")
    func camelCasedSingleWord() {
        let input = "word"
        let expectedOutput = "word"
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Camel case with non alphanumeric characters")
    func camelCasedWithNonAlphanumericCharacters() {
        let input = "hello!@#world"
        let expectedOutput = "helloWorld"
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Camel case with leading and trailing spaces")
    func camelCasedWithLeadingAndTrailingSpaces() {
        let input = "  leading and trailing spaces  "
        let expectedOutput = "leadingAndTrailingSpaces"
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Camel case with uppercase input")
    func camelCasedWithUppercaseInput() {
        let input = "THIS IS UPPERCASE"
        let expectedOutput = "thisIsUppercase"
        #expect(input.camelCased() == expectedOutput)
    }
    
    @Test("Camel case with mixed case input")
    func testCamelCasedWithMixedCaseInput() {
        let input = "tHis Is a MiXeD CaSe"
        let expectedOutput = "thisIsAMixedCase"
        #expect(input.camelCased() == expectedOutput)
    }
}
