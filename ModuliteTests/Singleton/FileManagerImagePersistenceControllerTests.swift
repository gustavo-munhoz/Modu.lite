//
//  FileManagerImagePersistenceControllerTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 17/09/24.
//

import XCTest
@testable import Modulite

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
        
        // Save the widget image
        let imageURL = controller.saveWidgetImage(image: testImage, for: widgetId)
        
        // Verify the file was saved at the correct location
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageURL.path))
        
        // Retrieve the image
        let retrievedImage = controller.getWidgetImage(with: widgetId)
        
        XCTAssertNotNil(retrievedImage, "Retrieved image should not be nil")
        
        // Optionally, compare the image data
        XCTAssertEqual(testImage.pngData(), retrievedImage?.pngData(), "The images should be equal")
    }
    
    func testSaveModuleImage() {
        let widgetId = UUID()
        let moduleIndex = 1
        let testImage = UIImage(systemName: "circle")!
        
        // Save the module image
        let imageURL = controller.saveModuleImage(image: testImage, for: widgetId, moduleIndex: moduleIndex)
        
        // Verify the file was saved at the correct location
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageURL.path))
    }
    
    func testDeleteWidgetAndModules() {
        let widgetId = UUID()
        let testImage = UIImage(systemName: "square")!
        
        // Save an image to create the directories
        _ = controller.saveWidgetImage(image: testImage, for: widgetId)
        
        // Verify the directory exists
        let widgetDirectory = testDirectory.appendingPathComponent("\(widgetId)")
        XCTAssertTrue(FileManager.default.fileExists(atPath: widgetDirectory.path))
        
        // Delete the widget and modules
        controller.deleteWidgetAndModules(with: widgetId)
        
        // Verify the directory was removed
        XCTAssertFalse(FileManager.default.fileExists(atPath: widgetDirectory.path))
    }
    
    func testGetWidgetImageWithNonExistentDirectory() {
        let widgetId = UUID()
        
        // Try to get an image from a non-existent directory
        let retrievedImage = controller.getWidgetImage(with: widgetId)
        
        XCTAssertNil(retrievedImage, "Retrieved image should be nil for a non-existent directory")
    }
}
