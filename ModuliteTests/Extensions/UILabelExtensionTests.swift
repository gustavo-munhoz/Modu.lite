//
//  UILabelExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 14/09/24.
//

import XCTest
import Testing
import UIKit
@testable import Modulite

struct UILabelExtensionsTests {
    
    @MainActor @Test("Label text is drawn with insets")
    func drawTextWithInsets() {
        let label = PaddedLabel()
        label.text = "Test"
        label.edgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
                
        let rect = CGRect(x: 0, y: 0, width: 100, height: 40)
        label.drawText(in: rect)
                
        let expectedRect = rect.inset(by: label.edgeInsets)
                
        #expect(expectedRect.origin == CGPoint(x: 15, y: 10))
        #expect(expectedRect.size == CGSize(width: 70, height: 20))
    }
    
    @MainActor @Test("Label intrinsic content size is calculated with insets")
    func intrinsicContentSizeWithInsets() {
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
        
        #expect(label.intrinsicContentSize.equalTo(expectedSize))
    }
    
    @MainActor @Test("Label with default insets has zero insets")
    func testDefaultInsets() {
        let label = PaddedLabel()
        label.text = "Test"
                
        #expect(label.edgeInsets == .zero)
        #expect(
            label.intrinsicContentSize.equalTo(
                label.sizeThatFits(
                    CGSize(
                        width: CGFloat.greatestFiniteMagnitude,
                        height: CGFloat.greatestFiniteMagnitude
                    )
                )
            )
        )
    }
}
