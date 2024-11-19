//
//  WidgetEditorViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit
import Photos
import WidgetStyling

class WidgetEditorViewModel: NSObject {
    
    // MARK: - Properties
    @Published private(set) var selectedCellPosition: Int?
    
    let builder: WidgetSchemaBuilder
    
    // MARK: - Initializers
    init(
        widgetBuider: WidgetSchemaBuilder
    ) {
        builder = widgetBuider
        super.init()
    }
    
    // MARK: - Getters
    
    func getIndexForSelectedStyle() -> Int? {
        guard let selectedStyle = getStyleFromSelectedModule() else { return nil }
        return getAvailableStyles().firstIndex(where: { $0.identifier == selectedStyle.identifier })
    }
    
    func getWidgetId() -> UUID {
        builder.getWidgetId()
    }
    
    func getWidgetBackground() -> StyleBackground {
        builder.getBackground()
    }
    
    func getIndexForSelectedModuleColor() -> Int? {
        guard let index = selectedCellPosition,
              let color = getColorFromSelectedModule() else { return nil }
        
        return getAvailableColorsForModule(at: index).firstIndex(of: color)
    }
    
    func getColorFromSelectedModule() -> UIColor? {
        guard let index = selectedCellPosition else { return nil }
        
        return try? builder.getModule(at: index).color
    }
    
    func getStyleFromSelectedModule() -> ModuleStyle? {
        guard let index = selectedCellPosition else { return nil }
        
        return try? builder.getModule(at: index).style
    }
    
    func getCurrentModules() -> [WidgetModule] {
        builder.getCurrentModules()
    }
    
    func getModule(at position: Int) -> WidgetModule? {
        try? builder.getModule(at: position)
    }
    
    func getAvailableStyles() -> [ModuleStyle] {
        builder.getAvailableModuleStyles()
    }
    
    func getAvailableStyle(at position: Int) -> ModuleStyle? {
        try? builder.getAvailableModuleStyle(at: position)
    }
    
    func getAvailableColorsForSelectedModule() -> [UIColor] {
        guard let index = selectedCellPosition else { return [] }
        return getAvailableColorsForModule(at: index)
    }
    
    func getAvailableColorsForModule(at position: Int) -> [UIColor] {
        (try? builder.getAvailableColorsForModule(at: position)) ?? []
    }
    
    func getAvailableColorForModule(at position: Int, colorIndex: Int) -> UIColor? {
        try? builder.getAvailableColorForModule(at: position, with: colorIndex)
    }
    
    func isModuleEmpty(at index: Int) -> Bool? {
        try? builder.isModuleEmpty(at: index)
    }
    
    // MARK: - Setters
    
    func setEditingCell(at index: Int) {
        selectedCellPosition = index
    }
    
    func clearEditingCell() {
        selectedCellPosition = nil
    }
    
    // MARK: - Actions
    func saveWallpaperImageToPhotos(completion: @escaping (Result<Void, Error>) -> Void) {
        let (blocked, home) = builder.getWallpapers().tuple()
        
        let screenSize = UIScreen.main.bounds.size
        
        guard let resizedBlocked = resizeImage(image: blocked, targetSize: screenSize),
              let resizedHome = resizeImage(image: home, targetSize: screenSize) else {
            completion(.failure(WallpaperSaveError.unableToSaveWallpaper))
            return
        }
        
        saveImagesToPhotoLibrary(
            images: [resizedBlocked, resizedHome],
            completion: completion
        )
    }

    private func saveImagesToPhotoLibrary(
        images: [UIImage],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        PHPhotoLibrary.shared().performChanges({
            for image in images {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }, completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                    return
                }
                
                if PHPhotoLibrary.authorizationStatus(for: .addOnly) != .authorized {
                    completion(.failure(WallpaperSaveError.photosAuthorizationDenied))
                    return
                }
                
                if let error = error {
                    completion(.failure(WallpaperSaveError.saveFailed(error)))
                    return
                }
                
                completion(.failure(WallpaperSaveError.wallpaperUnknownError))
            }
        })
    }
    
    @discardableResult
    func saveWidget(from collectionView: UICollectionView) -> WidgetSchema? {
        do {
            let widgetSchema = try builder.build()
            
            let widgetImage = collectionView.asImage()
            
            var moduleImages: [Int: UIImage] = [:]
            for cell in collectionView.visibleCells {
                guard let moduleCell = cell as? WidgetModuleCell else { continue }
                guard let indexPath = collectionView.indexPath(for: moduleCell) else { continue }
                
                let module = widgetSchema.modules[indexPath.item]
                let moduleImage = moduleCell.asImage()
                
                moduleImages[module.position] = moduleImage
            }
            
            let persistedSchema = CoreDataPersistenceController.shared.registerOrUpdateWidget(
                widgetSchema,
                widgetImage: widgetImage,
                moduleImages: moduleImages
            )
            
            widgetSchema.previewImage = FileManagerImagePersistenceController.shared.getWidgetImage(
                with: persistedSchema.id
            )
            
            return widgetSchema
            
        } catch {
            print("Could not save widget: \(error.localizedDescription).")
            return nil
        }
    }
    
    func moveItem(from sourcePosition: Int, to destinationPosition: Int) {
        try? builder.moveModule(from: sourcePosition, to: destinationPosition)
    }

    func applyColorToSelectedModule(_ color: UIColor) {
        guard let selectedCellPosition else {
            print("Tried to edit item without selecting any.")
            return
        }
        
        try? builder.setModuleColor(color, at: selectedCellPosition)
    }
    
    func applyStyleToSelectedModule(
        _ style: ModuleStyle,
        didSetToDefaultColor: @escaping (Bool) -> Void = { _ in }
    ) {
        guard let selectedCellPosition else {
            print("Tried to edit item without selecting any.")
            return
        }
        
        do {
            try builder.setModuleStyle(style, at: selectedCellPosition)
                        
            let currentColor = try builder.getModule(at: selectedCellPosition).color
            
            guard let canSetColor = (
                try? builder.getModule(at: selectedCellPosition).canSetColor(
                    to: currentColor
                )
            ), !canSetColor else { return }
            
            try builder.setModuleColor(
                style.defaultColor,
                at: selectedCellPosition
            )
            
            didSetToDefaultColor(true)
            
        } catch {
            print("Failed to apply style or set color: \(error)")
        }
    }
    
    // MARK: - Helper methods
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
