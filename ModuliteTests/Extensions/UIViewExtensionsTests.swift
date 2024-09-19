//
//  UIViewExtensionsTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import Testing
import UIKit
@testable import Modulite

@Suite("UIView tests") struct UIViewExtensionsTests {
    
    @MainActor @Test("View as image exists")
    func viewAsImageNotNil() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        
        let image = view.asImage()
        
        #expect(image != nil)
    }
    
    @MainActor @Test("View as image has correct size")
    func viewAsImageHasCorrectSize() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 200))
        view.backgroundColor = .blue
        
        let image = view.asImage()
        
        #expect(image.size.equalTo(view.bounds.size))
    }
    
    @MainActor @Test("View as image with subviews exists")
    func viewAsImageWithSubviews() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .white
                
        let subview = UIView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        subview.backgroundColor = .red
        view.addSubview(subview)
        
        let image = view.asImage()
        
        #expect(image != nil)
        #expect(image.size.equalTo(view.bounds.size))
    }
    
    @MainActor @Test("View as image with content exists")
    func viewAsImageContent() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .green
        
        let image = view.asImage()
        
        #expect(image != nil)
    }
}
