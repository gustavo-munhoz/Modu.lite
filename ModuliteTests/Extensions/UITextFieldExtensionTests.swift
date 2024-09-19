//
//  UITextFieldExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 14/09/24.
//

import Testing
import UIKit
@testable import Modulite

@Suite("UITextField tests") struct UITextFieldExtensionTests {

    @MainActor @Test("Left padding points are set")
    func setLeftPaddingPoints() {
        let textField = UITextField()
        let paddingAmount: CGFloat = 20.0
        
        textField.setLeftPaddingPoints(paddingAmount)
        
        #expect(textField.leftView != nil)
        #expect(textField.leftViewMode == .always)
                
        #expect(textField.leftView?.frame.width == paddingAmount)
        #expect(textField.leftView?.frame.height == textField.frame.size.height)
    }

    @MainActor @Test("Right padding points are set")
    func setRightPaddingPoints() {
        let textField = UITextField()
        let paddingAmount: CGFloat = 15.0
        
        textField.setRightPaddingPoints(paddingAmount)
                
        #expect(textField.rightViewMode != nil)
        #expect(textField.rightViewMode == .always)
                
        #expect(textField.rightView?.frame.width == paddingAmount)
        #expect(textField.rightView?.frame.height == textField.frame.size.height)
    }
}
