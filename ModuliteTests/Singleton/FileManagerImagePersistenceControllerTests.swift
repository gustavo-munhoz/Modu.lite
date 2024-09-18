//
//  FileManagerImagePersistenceControllerTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 17/09/24.
//

import Testing
import XCTest
@testable import Modulite

final class FileManagerImageTests {
    var controller: FileManagerImagePersistenceController!
    var testDirectory: URL!
    
    init() {
        testDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        do {
            try FileManager.default.createDirectory(
                at: testDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            XCTFail("Failed to create temporary directory: \(error)")
        }
        
        controller = FileManagerImagePersistenceController(baseDirectory: testDirectory)
    }
    
    deinit {
        do {
            try FileManager.default.removeItem(at: testDirectory)
        } catch {
            print("Failed to remove temporary directory: \(error)")
        }
    }
    
    @Test func testSaveAndGetWidgetImage() {
        let widgetId = UUID()
        let testImage = UIImage(systemName: "star")!
        
        let imageURL = controller.saveWidgetImage(image: testImage, for: widgetId)
        
        #expect(FileManager.default.fileExists(atPath: imageURL.path))
        
        let retrievedImage = controller.getWidgetImage(with: widgetId)
        
        #expect(retrievedImage != nil, "Retrieved image should not be nil")
    }
    
}

// swiftlint:disable:next type_name
class FileManagerImagePersistenceControllerTests: XCTestCase {
    
    var controller: FileManagerImagePersistenceController!
    var testDirectory: URL!
    
    override func setUp() {
        super.setUp()
        
        testDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        do {
            try FileManager.default.createDirectory(
                at: testDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            XCTFail("Failed to create temporary directory: \(error)")
        }
        
        controller = FileManagerImagePersistenceController(baseDirectory: testDirectory)
    }
    
    override func tearDown() {
        do {
            try FileManager.default.removeItem(at: testDirectory)
        } catch {
            print("Failed to remove temporary directory: \(error)")
        }
        
        super.tearDown()
    }
    
    
    func testSaveAndGetWidgetImage() {
        let widgetId = UUID()
        let testImage = UIImage(systemName: "star")!
        
        let imageURL = controller.saveWidgetImage(image: testImage, for: widgetId)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageURL.path))
        
        let retrievedImage = controller.getWidgetImage(with: widgetId)
        
        XCTAssertNotNil(retrievedImage, "Retrieved image should not be nil")
    }
    
    func testSaveModuleImage() {
        let widgetId = UUID()
        let moduleIndex = 1
        let testImage = UIImage(systemName: "circle")!
        
        let imageURL = controller.saveModuleImage(image: testImage, for: widgetId, moduleIndex: moduleIndex)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageURL.path))
    }
    
    func testDeleteWidgetAndModules() {
        let widgetId = UUID()
        let testImage = UIImage(systemName: "square")!
        
        _ = controller.saveWidgetImage(image: testImage, for: widgetId)
        
        let widgetDirectory = testDirectory.appendingPathComponent("\(widgetId)")
        XCTAssertTrue(FileManager.default.fileExists(atPath: widgetDirectory.path))
        
        controller.deleteWidgetAndModules(with: widgetId)
        
        XCTAssertFalse(FileManager.default.fileExists(atPath: widgetDirectory.path))
    }
    
    func testGetWidgetImageWithNonExistentDirectory() {
        let widgetId = UUID()
        
        let retrievedImage = controller.getWidgetImage(with: widgetId)
        
        XCTAssertNil(retrievedImage, "Retrieved image should be nil for a non-existent directory")
    }
}
