//
//  StringExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import Testing
import UIKit
@testable import Modulite

@Suite("String tests")
struct StringExtensionsTests {
    
    enum TestCase: String, CaseIterable {
        case multipleWords = "this is a test"
        case specialCharacters = "this_is-a.test"
        case alreadyCamelCase = "thisIsATest"
        case emptyString = ""
        case singleWord = "test"
        case nonAlphanumericCharacters = "this!is$a!@#test"
        case leadingAndTrailingWhitespaces = "   this  is  a  test   "
        case uppercased = "THIS IS A TEST"
        case mixedCase = "ThIs Is A TeSt"
        
        var camelCased: String {
            switch self {
            case .singleWord: return "test"
            case .emptyString: return ""
            default: return "thisIsATest"
            }
        }
    }
    
    @Test("Camel cased strings", arguments: TestCase.allCases)
    func allStringOptions(_ testCase: TestCase) {
        #expect(testCase.rawValue.camelCased() == testCase.camelCased)
    }
}
