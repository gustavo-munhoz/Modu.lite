//
//  UIImageExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import XCTest
@testable import Modulite

class UIViewExtensionsTests: XCTestCase {
    
    func testViewAsImageNotNil() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        
        let image = view.asImage()
        
        XCTAssertNotNil(image, "The generated image should not be nil.")
    }
    
    func testViewAsImageHasCorrectSize() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 200))
        view.backgroundColor = .blue
        
        let image = view.asImage()
        
        XCTAssertEqual(
            image.size.width,
            view.bounds.width,
            "The width of the generated image should match the view's width."
        )
        
        XCTAssertEqual(
            image.size.height,
            view.bounds.height,
            "The height of the generated image should match the view's height."
        )
    }
    
    func testViewAsImageWithSubviews() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .white
                
        let subview = UIView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        subview.backgroundColor = .red
        view.addSubview(subview)
        
        let image = view.asImage()
        
        XCTAssertNotNil(image, "The generated image with subviews should not be nil.")
        XCTAssertEqual(
            image.size.width,
            view.bounds.width,
            "The width of the generated image should match the view's width."
        )
        
        XCTAssertEqual(
            image.size.height,
            view.bounds.height,
            "The height of the generated image should match the view's height."
        )
    }
    
    func testViewAsImageContent() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .green
        
        let image = view.asImage()
                
        XCTAssertNotNil(image, "The generated image should not be nil.")
    }
}
