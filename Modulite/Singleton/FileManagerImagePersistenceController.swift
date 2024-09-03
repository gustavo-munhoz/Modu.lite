//
//  FileManagerImagePersistenceController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/09/24.
//

import UIKit

class FileManagerImagePersistenceController {
    
    static let shared = FileManagerImagePersistenceController()
    
    private init() { }
    
    func saveWidget(image: UIImage, for widgetId: UUID) -> URL {
        let (widgetDirectory, _) = setupDirectories(for: widgetId)
        return saveImage(image, in: widgetDirectory, withName: "widget")
    }
    
    func saveModule(image: UIImage, for widgetId: UUID, moduleIndex: Int) -> URL {
        let (_, modulesDirectory) = setupDirectories(for: widgetId)
        return saveImage(image, in: modulesDirectory, withName: "\(moduleIndex)")
    }
    
    func deleteWidget(with id: UUID) {
        let fileManager = FileManager.default
        guard let widgetDirectory = getDirectory(for: id) else {
            print("Directory not found for widget with ID \(id)")
            return
        }
        
        do {
            try fileManager.removeItem(at: widgetDirectory)
            print("Successfully deleted widget with ID \(id)")
        } catch {
            print("Failed to delete widget with ID \(id): \(error)")
        }
    }
}

// MARK: - Directory handlers
extension FileManagerImagePersistenceController {
    private func setupDirectories(for widgetId: UUID) -> (widgetDirectory: URL, modulesDirectory: URL) {
        let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
    
    private func getDirectory(for id: UUID) -> URL? {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
        
        return documentsDirectory?.appendingPathComponent(id.uuidString)
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
