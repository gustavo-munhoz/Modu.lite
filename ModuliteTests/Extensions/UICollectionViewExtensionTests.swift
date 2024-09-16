//
//  UICollectionViewExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 15/09/24.
//

import XCTest
@testable import Modulite

class UICollectionViewCellExtensionTests: XCTestCase {
    
    func testToggleIsHighlightedTrue() {
        let cell = UICollectionViewCell()
                
        cell.isHighlighted = true
        cell.toggleIsHighlighted()
                
        let expectation = XCTestExpectation(description: "Wait for animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(
                cell.alpha,
                0.9,
                accuracy: 0.0001,
                "The alpha should be approximately 0.9 when the cell is highlighted."
            )
            XCTAssertEqual(
                cell.transform.a,
                0.97,
                accuracy: 0.0001,
                "The transform's scale on x-axis should be approximately 0.97 when the cell is highlighted."
            )
            XCTAssertEqual(
                cell.transform.d,
                0.97,
                accuracy: 0.0001,
                "The transform's scale on y-axis should be approximately 0.97 when the cell is highlighted."
            )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testToggleIsHighlightedFalse() {
        let cell = UICollectionViewCell()
                
        cell.isHighlighted = false
        cell.toggleIsHighlighted()
                
        let expectation = XCTestExpectation(description: "Wait for animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(
                cell.alpha,
                1.0,
                accuracy: 0.0001,
                "The alpha should be approximately 1.0 when the cell is not highlighted."
            )
            XCTAssertEqual(
                cell.transform,
                CGAffineTransform.identity,
                "The transform should be identity when the cell is not highlighted."
            )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
