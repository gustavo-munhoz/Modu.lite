//
//  UIColorValueTransformerTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import Testing
import UIKit
@testable import Modulite

struct UIColorValueTransformerTests {
    
    @Test("Value is transformed to Data")
    func transformValueToData() {
        let transformer = UIColorValueTransformer()
        let color = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
        
        let transformedValue = transformer.transformedValue(color)
        
        #expect(transformedValue != nil)
        #expect(transformedValue is Data)
    }
    
    @Test("Transformed Data is reverted to UIColor")
    func reverseTransformedValueToUIColor() {
        let transformer = UIColorValueTransformer()
        let color = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
        
        let transformedValue = transformer.transformedValue(color)
        
        #expect(transformedValue != nil)
        
        let revertedValue = transformer.reverseTransformedValue(transformedValue) as? UIColor
        
        #expect(revertedValue != nil)
        #expect(color == revertedValue)
    }
    
    @Test("Invalid Value is not transformed")
    func trasnformInvalidValue() {
        let transformer = UIColorValueTransformer()
        let invalidInput = "Invalid Input"
        
        let transformedValue = transformer.transformedValue(invalidInput)
        
        #expect(transformedValue == nil)
    }
    
    @Test("Nil Value is not transformed")
    func transformNilValue() {
        let transformer = UIColorValueTransformer()
        
        let transformedValue = transformer.transformedValue(nil)
        
        #expect(transformedValue == nil)
    }
    
    @Test("Invalid Data is not reverted")
    func reverseTransformInvalidData() {
        let transformer = UIColorValueTransformer()
        let invalidData = Data([0x00, 0x01, 0x02])
                
        let reversedValue = transformer.reverseTransformedValue(invalidData)
        
        #expect(reversedValue == nil)
    }
    
    @Test("Nil value is not reverted")
    func reverseTransformNilValue() {
        let transformer = UIColorValueTransformer()
        
        let revertedValue = transformer.reverseTransformedValue(nil)
        
        #expect(revertedValue == nil)
    }
}
