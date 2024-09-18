//
//  FileManagerImagePersistenceController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/09/24.
//

import UIKit

protocol WidgetImagePersistenceController {
    func saveWidgetImage(image: UIImage, for widgetId: UUID) -> URL
    func saveModuleImage(image: UIImage, for widgetId: UUID, moduleIndex: Int) -> URL
    func getWidgetImage(with id: UUID) -> UIImage?
    func deleteWidgetAndModules(with id: UUID)
}

class FileManagerImagePersistenceController: WidgetImagePersistenceController {
    
    static let shared = FileManagerImagePersistenceController()
    
    private let baseDirectory: URL
    
    init(baseDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!) {
        self.baseDirectory = baseDirectory
    }
    
    func getWidgetImage(with id: UUID) -> UIImage? {
        let url = getDirectory(for: id)
        
        let completeUrl = url.appending(component: "widget.png")
        
        if let imageData = try? Data(contentsOf: completeUrl) {
            return UIImage(data: imageData)
        } else {
            print("Unable to load image data from \(completeUrl)")
            return nil
        }
    }
    
    @discardableResult
    func saveWidgetImage(image: UIImage, for widgetId: UUID) -> URL {
        let (widgetDirectory, _) = setupDirectories(for: widgetId)
        return saveImage(image, in: widgetDirectory, withName: "widget")
    }
    
    @discardableResult
    func saveModuleImage(image: UIImage, for widgetId: UUID, moduleIndex: Int) -> URL {
        let (_, modulesDirectory) = setupDirectories(for: widgetId)
        return saveImage(image, in: modulesDirectory, withName: "\(moduleIndex)")
    }
    
    func deleteWidgetAndModules(with id: UUID) {
        let widgetDirectory = getDirectory(for: id)
        
        do {
            try FileManager.default.removeItem(at: widgetDirectory)
            print("Successfully deleted widget with ID \(id)")
        } catch {
            print("Failed to delete widget with ID \(id): \(error)")
        }
    }
}

// MARK: - Directory handlers
extension FileManagerImagePersistenceController {
    private func setupDirectories(for widgetId: UUID) -> (widgetDirectory: URL, modulesDirectory: URL) {
        let widgetDirectory = baseDirectory.appendingPathComponent("\(widgetId)")
        let modulesDirectory = widgetDirectory.appendingPathComponent("modules")
        
        do {
            if !FileManager.default.fileExists(atPath: widgetDirectory.path) {
                try FileManager.default.createDirectory(
                    at: widgetDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
            if !FileManager.default.fileExists(atPath: modulesDirectory.path) {
                try FileManager.default.createDirectory(
                    at: modulesDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
        } catch {
            fatalError("Failed to create directories: \(error.localizedDescription)")
        }
        
        return (widgetDirectory, modulesDirectory)
    }
    
    private func getDirectory(for id: UUID) -> URL {
        baseDirectory.appendingPathComponent(id.uuidString)
    }
}

// MARK: - Image handling
extension FileManagerImagePersistenceController {
    private func saveImage(_ image: UIImage, in directory: URL, withName name: String) -> URL {
        let imageData = image.pngData()
        let imageURL = directory.appendingPathComponent("\(name).png")
        
        do {
            try imageData?.write(to: imageURL)
            return imageURL
        } catch {
            fatalError("Failed to save image: \(error.localizedDescription)")
        }
    }
}
