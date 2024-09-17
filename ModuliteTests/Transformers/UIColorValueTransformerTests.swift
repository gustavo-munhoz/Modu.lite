//
//  UIColorValueTransformerTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import XCTest
@testable import Modulite

class UIColorValueTransformerTests: XCTestCase {
    
    func testTransformedValueToData() {
        let transformer = UIColorValueTransformer()
        let color = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
                
        let transformedValue = transformer.transformedValue(color)
        
        XCTAssertNotNil(transformedValue)
        XCTAssertTrue(transformedValue is Data)
    }
    
    func testReverseTransformedValueToUIColor() {
        let transformer = UIColorValueTransformer()
        let originalColor = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
                
        let transformedValue = transformer.transformedValue(originalColor) as? Data
        
        XCTAssertNotNil(transformedValue)
                
        let reversedValue = transformer.reverseTransformedValue(transformedValue) as? UIColor
        
        XCTAssertNotNil(reversedValue)
        XCTAssertEqual(originalColor, reversedValue)
    }
    
    func testReverseTransformInvalidData() {
        let transformer = UIColorValueTransformer()
        let invalidData = Data([0x00, 0x01, 0x02])
                
        let reversedValue = transformer.reverseTransformedValue(invalidData)
        
        XCTAssertNil(reversedValue)
    }
    
    func testTransformedValueWithInvalidInput() {
        let transformer = UIColorValueTransformer()
        let invalidInput = "Invalid Input"
                
        let transformedValue = transformer.transformedValue(invalidInput)
        
        XCTAssertNil(transformedValue)
    }
    
    func testReverseTransformWithNilInput() {
        let transformer = UIColorValueTransformer()
                
        let reversedValue = transformer.reverseTransformedValue(nil)
        
        XCTAssertNil(reversedValue)
    }
    
    func testTransformedValueWithNilInput() {
        let transformer = UIColorValueTransformer()
                
        let transformedValue = transformer.transformedValue(nil)
        
        XCTAssertNil(transformedValue)
    }
}
