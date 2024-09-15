//
//  UIEdgeInsetExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import XCTest
@testable import Modulite

class UIEdgeInsetsExtensionsTests: XCTestCase {
    
    func testUIEdgeInsetsVerticalAndHorizontal() {
        let vertical: CGFloat = 10.0
        let horizontal: CGFloat = 20.0
        
        let insets = UIEdgeInsets(vertical: vertical, horizontal: horizontal)
        
        XCTAssertEqual(insets.top, vertical, "The top inset should be equal to the vertical value.")
        XCTAssertEqual(insets.bottom, vertical, "The bottom inset should be equal to the vertical value.")
        XCTAssertEqual(insets.left, horizontal, "The left inset should be equal to the horizontal value.")
        XCTAssertEqual(insets.right, horizontal, "The right inset should be equal to the horizontal value.")
    }
    
    func testUIEdgeInsetsWithZeroValues() {
        let vertical: CGFloat = 0.0
        let horizontal: CGFloat = 0.0
        
        let insets = UIEdgeInsets(vertical: vertical, horizontal: horizontal)
        
        XCTAssertEqual(insets.top, vertical, "The top inset should be equal to zero.")
        XCTAssertEqual(insets.bottom, vertical, "The bottom inset should be equal to zero.")
        XCTAssertEqual(insets.left, horizontal, "The left inset should be equal to zero.")
        XCTAssertEqual(insets.right, horizontal, "The right inset should be equal to zero.")
    }
    
    func testUIEdgeInsetsWithNegativeValues() {
        let vertical: CGFloat = -5.0
        let horizontal: CGFloat = -10.0
        
        let insets = UIEdgeInsets(vertical: vertical, horizontal: horizontal)
        
        XCTAssertEqual(insets.top, vertical, "The top inset should be equal to the negative vertical value.")
        XCTAssertEqual(insets.bottom, vertical, "The bottom inset should be equal to the negative vertical value.")
        XCTAssertEqual(insets.left, horizontal, "The left inset should be equal to the negative horizontal value.")
        XCTAssertEqual(insets.right, horizontal, "The right inset should be equal to the negative horizontal value.")
    }
}
