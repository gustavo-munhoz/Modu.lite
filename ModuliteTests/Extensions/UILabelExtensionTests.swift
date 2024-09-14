//
//  UILabelExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 14/09/24.
//

import XCTest
@testable import Modulite

class UILabelExtensionsTests: XCTestCase {
    func testDrawTextWithInsets() {
        let label = PaddedLabel()
        label.text = "Test"
        label.edgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
                
        let rect = CGRect(x: 0, y: 0, width: 100, height: 40)
        label.drawText(in: rect)
                
        let expectedRect = rect.inset(by: label.edgeInsets)
                
        XCTAssertEqual(expectedRect.origin.x, 15)
        XCTAssertEqual(expectedRect.origin.y, 10)
        XCTAssertEqual(expectedRect.size.width, 70)
        XCTAssertEqual(expectedRect.size.height, 20)
    }
    
    func testIntrinsicContentSizeWithInsets() {
        let label = PaddedLabel()
        label.text = "Test"
        label.edgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
                
        let baseSize = label.sizeThatFits(
            CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        let expectedSize = CGSize(
            width: baseSize.width + label.edgeInsets.left + label.edgeInsets.right,
            height: baseSize.height + label.edgeInsets.top + label.edgeInsets.bottom
        )
        
        XCTAssertEqual(label.intrinsicContentSize.width, expectedSize.width)
        XCTAssertEqual(label.intrinsicContentSize.height, expectedSize.height)
    }
    
    func testDefaultInsets() {
        let label = PaddedLabel()
        label.text = "Test"
                
        XCTAssertEqual(label.edgeInsets, .zero)
        XCTAssertEqual(
            label.intrinsicContentSize,
            label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        )
    }
}
