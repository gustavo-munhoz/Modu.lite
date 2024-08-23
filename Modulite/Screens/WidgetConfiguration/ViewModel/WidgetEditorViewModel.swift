//
//  WidgetEditorViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit
import Combine

class WidgetEditorViewModel: NSObject {
    
    private(set) var widgetId: UUID!
    
    private(set) weak var delegate: HomeNavigationFlowDelegate?
    
    private let selectedApps: [UIImage] = Array(repeating: UIImage(named: "att-regular2")!, count: 4)
    
    @Published private(set) var displayedModules: [UIImage?] = Array(repeating: nil, count: 6)
    
    private(set) lazy var availableStyles = [
        baseImage, baseImage, baseImage, baseImage
    ]
    
    private(set) var availableColors: [UIColor] = [
        .eggYolk, .cupcake, .sweetTooth, .sugarMint, .burntEnds
    ]
    
    private let baseImage = UIImage(named: "att-regular2")!
    
    @Published private(set) var editingCellWithIndex: Int?
    
    override init() {
        super.init()
                        
        for i in 0..<selectedApps.count {
            displayedModules[i] = selectedApps[i]
        }
    }
    
    // MARK: - Setters
    func setDelegate(to delegate: HomeNavigationFlowDelegate) {
        self.delegate = delegate
    }
    
    func setWidgetId(to id: UUID) {
        self.widgetId = id
    }
    
    func setEditingCell(at index: Int) {
        editingCellWithIndex = index
    }
    
    func clearEditingCell() {
        editingCellWithIndex = nil
    }
    
    // MARK: - Actions
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0, sourceIndex < displayedModules.count,
              destinationIndex >= 0, destinationIndex < displayedModules.count else {
            print("Invalid indices")
            return
        }

        let movingItem = displayedModules[sourceIndex]
        displayedModules.remove(at: sourceIndex)
        displayedModules.insert(movingItem, at: destinationIndex)
    }

    func applyColorToSelectedCell(color: UIColor) {
        guard let index = editingCellWithIndex else {
            print("Tried to edit item without selecting any.")
            return
        }
        
        guard displayedModules[index] != nil else {
            print("Item at position \(index) is nil")
            return
        }
        
        displayedModules[index] = ImageProcessingFactory.createColorBlendedImage(
            baseImage,
            mode: .plusDarker,
            color: color
        )
        
        availableStyles = availableStyles.map { _ in
            ImageProcessingFactory.createColorBlendedImage(
                baseImage,
                mode: .plusDarker,
                color: color
            )!
        }
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
