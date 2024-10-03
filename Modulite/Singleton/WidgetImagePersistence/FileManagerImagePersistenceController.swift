//
//  FileManagerImagePersistenceController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/09/24.
//

import UIKit

class FileManagerImagePersistenceController {
    
    static let shared = FileManagerImagePersistenceController()
    
    private let baseDirectory: URL
    
    init(baseDirectory: URL? = nil) {
        if let baseDirectory = baseDirectory {
            self.baseDirectory = baseDirectory
            return
        }
        
        guard let appGroupID = Bundle.main.object(forInfoDictionaryKey: "AppGroupID") as? String else {
            fatalError("Could not find App Group ID in Info.plist")
        }
        
        guard let appGroupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else {
            fatalError("Could not find App Group container")
        }
        
        self.baseDirectory = appGroupURL
    }
    
    // MARK: - Getters
    
    func getWidgetImage(with id: UUID) -> UIImage? {
        let url = getDirectory(for: id)
        
        let completeUrl = url.appending(component: "widget.png")
        
        guard let imageData = try? Data(contentsOf: completeUrl) else {
            print("Unable to load image data from \(completeUrl)")
            return nil
        }
        
        return UIImage(data: imageData)
    }
    
    func getModuleImages(for widgetId: UUID) -> [UIImage] {
        let widgetDirectory = getDirectory(for: widgetId)
        let modulesDirectory = widgetDirectory.appendingPathComponent("modules")
        
        var images: [UIImage] = []
        
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: modulesDirectory.path)
                        
            let pngFiles = fileNames.filter { $0.hasSuffix(".png") }
                        
            let indexFileMap: [(Int, String)] = pngFiles.compactMap { fileName in
                let indexString = fileName.replacingOccurrences(of: ".png", with: "")
                guard let index = Int(indexString) else { return nil }
                
                return (index, fileName)
            }
                        
            let sortedIndexFileMap = indexFileMap.sorted { $0.0 < $1.0 }
                        
            for (_, fileName) in sortedIndexFileMap {
                let fileURL = modulesDirectory.appendingPathComponent(fileName)
                guard let imageData = try? Data(contentsOf: fileURL),
                      let image = UIImage(data: imageData) else { continue }
                
                images.append(image)
            }
        } catch {
            print("Error accessing modules directory: \(error)")
        }
        
        return images
    }
    
    // MARK: - Save images
    
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
    
    // MARK: - Delete images
    
    func deleteWidgetAndModules(widgetId id: UUID) {
        let widgetDirectory = getDirectory(for: id)
        
        do {
            try FileManager.default.removeItem(at: widgetDirectory)
            print("Successfully deleted widget images.")
            
        } catch {
            print("Failed to delete widget images for ID \(id): \(error)")
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
