//
//  UITextFieldExtensionsTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 14/09/24.
//

import XCTest
@testable import Modulite

class UITextFieldExtensionsTests: XCTestCase {

    func testSetLeftPaddingPoints() {
        let textField = UITextField()
        let paddingAmount: CGFloat = 20.0
        
        textField.setLeftPaddingPoints(paddingAmount)
                
        XCTAssertNotNil(textField.leftView, "Left view should not be nil.")
        XCTAssertEqual(textField.leftViewMode, .always, "Left view mode should be set to .always.")
                
        XCTAssertEqual(
            textField.leftView?.frame.width,
            paddingAmount,
            "Left view width should be equal to the padding amount."
        )
        XCTAssertEqual(
            textField.leftView?.frame.height,
            textField.frame.size.height,
            "Left view height should match the text field height."
        )
    }

    func testSetRightPaddingPoints() {
        let textField = UITextField()
        let paddingAmount: CGFloat = 15.0
        
        textField.setRightPaddingPoints(paddingAmount)
                
        XCTAssertNotNil(textField.rightView, "Right view should not be nil.")
        XCTAssertEqual(textField.rightViewMode, .always, "Right view mode should be set to .always.")
                
        XCTAssertEqual(
            textField.rightView?.frame.width,
            paddingAmount,
            "Right view width should be equal to the padding amount."
        )
        XCTAssertEqual(
            textField.rightView?.frame.height,
            textField.frame.size.height,
            "Right view height should match the text field height."
        )
    }
}
