//
//  WidgetEditorViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit
import Photos

class WidgetEditorViewModel: NSObject {
    
    // MARK: - Properties
    @Published private(set) var selectedCellIndex: Int?
    
    let builder: WidgetConfigurationBuilder
    
    // MARK: - Initializers
    init(
        widgetBuider: WidgetConfigurationBuilder
    ) {
        builder = widgetBuider
        super.init()
    }
    
    // MARK: - Getters
    
    func getWidgetId() -> UUID {
        builder.getWidgetId()
    }
    
    func getWidgetBackground() -> WidgetBackground? {
        builder.getStyleBackground()
    }
    
    func getColorFromSelectedModule() -> UIColor? {
        guard let index = selectedCellIndex else { return nil }
        
        return builder.getModule(at: index)?.selectedColor
    }
    
    func getStyleFromSelectedModule() -> ModuleStyle? {
        guard let index = selectedCellIndex else { return nil }
        
        return builder.getModule(at: index)?.selectedStyle
    }
    
    func getCurrentModules() -> [ModuleConfiguration?] {
        builder.getCurrentModules()
    }
    
    func getModule(at index: Int) -> ModuleConfiguration? {
        builder.getModule(at: index)
    }
    
    func getAvailableStyles() -> [ModuleStyle] {
        builder.getAvailableStyles()
    }
    
    func getAvailableStyle(at index: Int) -> ModuleStyle? {
        builder.getAvailableStyle(at: index)
    }
    
    func getAvailableColors() -> [UIColor] {
        builder.getAvailableColors()
    }
    
    func getAvailableColor(at index: Int) -> UIColor? {
        builder.getAvailableColor(at: index)
    }
    
    func isModuleEmpty(at index: Int) -> Bool {
        builder.isModuleEmpty(at: index)
    }
    
    // MARK: - Setters
    
    func setEditingCell(at index: Int) {
        selectedCellIndex = index
    }
    
    func clearEditingCell() {
        selectedCellIndex = nil
    }
    
    // MARK: - Actions
    func saveWallpaperImageToPhotos(completion: @escaping (Result<Void, Error>) -> Void) {
        let (blocked, home) = builder.getStyleWallpapers()
        
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
    func saveWidget(from collectionView: UICollectionView) -> ModuliteWidgetConfiguration {
        let widgetConfiguration = builder.build()
        let persistedConfig = CoreDataPersistenceController.shared.registerOrUpdateWidget(
            widgetConfiguration,
            widgetImage: collectionView.asImage()
        )
        
        widgetConfiguration.previewImage = FileManagerImagePersistenceController.shared.getWidgetImage(
            with: persistedConfig.id
        )
        
        return widgetConfiguration
    }
    
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        builder.moveItem(from: sourceIndex, to: destinationIndex)
    }

    func applyColorToSelectedModule(_ color: UIColor) {
        guard let index = selectedCellIndex else {
            print("Tried to edit item without selecting any.")
            return
        }
        
        builder.setModuleColor(at: index, color: color)
    }
    
    func applyStyleToSelectedModule(_ style: ModuleStyle) {
        guard let index = selectedCellIndex else {
            print("Tried to edit item without selecting any.")
            return
        }
        
        builder.setModuleStyle(at: index, style: style)
    }
    
    // MARK: - Helper methods
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
