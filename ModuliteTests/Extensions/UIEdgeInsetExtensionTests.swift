//
//  UIEdgeInsetExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import Testing
import UIKit
@testable import Modulite

@Suite("UIEdgeInsets tests")
struct UIEdgeInsetsExtensionsTests {
    
    enum TestCase: CaseIterable {
        case positive
        case zero
        case negative
        
        var vertical: CGFloat {
            switch self {
            case .positive: return 10.0
            case .zero: return 0.0
            case .negative: return -5.0
            }
        }
        
        var horizontal: CGFloat {
            switch self {
            case .positive: return 20.0
            case .zero: return 0.0
            case .negative: return -10.0
            }
        }
    }
    
    @Test("Edge insets are set", arguments: TestCase.allCases)
    func setEdgeInsets(_ testCase: TestCase) {
        let insets = UIEdgeInsets(vertical: testCase.vertical, horizontal: testCase.horizontal)
        
        #expect(insets.top == testCase.vertical)
        #expect(insets.bottom == testCase.vertical)
        #expect(insets.left == testCase.horizontal)
        #expect(insets.right == testCase.horizontal)
    }
}
