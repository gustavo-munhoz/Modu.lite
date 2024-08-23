//
//  WidgetEditorViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit
import Combine

class WidgetEditorViewModel: NSObject {
        
    private(set) weak var delegate: HomeNavigationFlowDelegate?
    
    @Published private(set) var selectedCellIndex: Int?
    
    unowned let builder: WidgetConfigurationBuilder
    
    init(
        widgetBuider: WidgetConfigurationBuilder,
        delegate: HomeNavigationFlowDelegate
    ) {
        builder = widgetBuider
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - Getters
    
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
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        builder.moveItem(from: sourceIndex, to: destinationIndex)
    }

    func applyColorToSelectedCell(color: UIColor? = .clear) {
        guard let index = selectedCellIndex else {
            print("Tried to edit item without selecting any.")
            return
        }
//        
//        guard displayedModules[index] != nil else {
//            print("Item at position \(index) is nil")
//            return
//        }
//        
//        displayedModules[index] = ImageProcessingFactory.createColorBlendedImage(
//            baseImage,
//            mode: .plusDarker,
//            color: color
//        )
//        
//        availableStyles = availableStyles.map { _ in
//            ImageProcessingFactory.createColorBlendedImage(
//                baseImage,
//                mode: .plusDarker,
//                color: color
//            )!
//        }
    }
    
//    func insertCell(_ image: UIImage, at index: Int) {
//        guard index >= 0 && index < 6 else {
//            fatalError("Tried to insert cell at invalid index: \(index)")
//        }
//        displayedModules[index] = image
//    }
//    
//    func removeCell(at index: Int) {
//        guard index >= 0 && index < 6 else {
//            fatalError("Tried to remove cell at invalid index: \(index)")
//        }
//        displayedModules[index] = nil
//    }
}
