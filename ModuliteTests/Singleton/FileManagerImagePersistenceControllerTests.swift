//
//  FileManagerImagePersistenceControllerTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 17/09/24.
//

import Testing
import UIKit
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
            Issue.record("Failed to create temporary directory: \(error)")
        }
        
        controller = FileManagerImagePersistenceController(baseDirectory: testDirectory)
    }
    
    deinit {
        do {
            try FileManager.default.removeItem(at: testDirectory)
            
        } catch {
            Issue.record("Failed to remove temporary directory: \(error)")
        }
    }
    
    @Test("Widget image is saved and recovered")
    func saveAndGetWidgetImage() {
        let widgetId = UUID()
        let testImage = UIImage(systemName: "star")!
        
        let imageURL = controller.saveWidgetImage(image: testImage, for: widgetId)
        
        #expect(FileManager.default.fileExists(atPath: imageURL.path))
        
        let retrievedImage = controller.getWidgetImage(with: widgetId)
        
        #expect(retrievedImage != nil, "Retrieved image should not be nil")
    }
    
    @Test("Module images are saved")
    func saveModuleImages() {
        let widgetId = UUID()
        let moduleIndex = 1
        let testImage = UIImage(systemName: "square")!
        
        let imageURL = controller.saveModuleImage(image: testImage, for: widgetId, moduleIndex: moduleIndex)
        
        #expect(FileManager.default.fileExists(atPath: imageURL.path))
    }
    
    @Test("Widget and module images are deleted")
    func deleteWidgetAndModules() {
        let widgetId = UUID()
        let testImage = UIImage(systemName: "square")!
        
        controller.saveWidgetImage(image: testImage, for: widgetId)
        controller.saveModuleImage(image: testImage, for: widgetId, moduleIndex: 1)
        
        let widgetDirectory = testDirectory.appendingPathComponent("\(widgetId)")
        #expect(FileManager.default.fileExists(atPath: widgetDirectory.path()))
        
        controller.deleteWidgetAndModules(with: widgetId)
        
        #expect(!FileManager.default.fileExists(atPath: widgetDirectory.path()))
    }
    
    @Test("Widget does not exist")
    func getWidgetWithNonExistentDirectory() {
        let widgetId = UUID()
        
        let retrievedImage = controller.getWidgetImage(with: widgetId)
        
        #expect(retrievedImage == nil)
    }
}
