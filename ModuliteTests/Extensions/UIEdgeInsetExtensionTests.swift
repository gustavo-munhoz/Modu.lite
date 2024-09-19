//
//  UIEdgeInsetExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import Testing
import UIKit
@testable import Modulite

@Suite("UIEdgeInsets tests") struct UIEdgeInsetsExtensionsTests {
    
    @Test("Edge insets are set with positive values")
    func edgeInsetsVerticalAndHorizontal() {
        let vertical: CGFloat = 10.0
        let horizontal: CGFloat = 20.0
        
        let insets = UIEdgeInsets(vertical: vertical, horizontal: horizontal)
        
        #expect(insets.top == vertical)
        #expect(insets.bottom == vertical)
        #expect(insets.left == horizontal)
        #expect(insets.right == horizontal)
    }
    
    @Test("Edge insets are set with zero values")
    func edgeInsetsWithZeroValues() {
        let vertical: CGFloat = 0.0
        let horizontal: CGFloat = 0.0
        
        let insets = UIEdgeInsets(vertical: vertical, horizontal: horizontal)
        
        #expect(insets.top == vertical)
        #expect(insets.bottom == vertical)
        #expect(insets.left == horizontal)
        #expect(insets.right == horizontal)
    }
    
    @Test("Edge insets are set with negative values")
    func edgeInsetsWithNegativeValues() {
        let vertical: CGFloat = -5.0
        let horizontal: CGFloat = -10.0
        
        let insets = UIEdgeInsets(vertical: vertical, horizontal: horizontal)
        
        #expect(insets.top == vertical)
        #expect(insets.bottom == vertical)
        #expect(insets.left == horizontal)
        #expect(insets.right == horizontal)
    }
}
