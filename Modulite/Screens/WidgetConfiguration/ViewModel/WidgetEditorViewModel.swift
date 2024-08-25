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
    
    func getColorFromSelectedModule() -> UIColor? {
        guard let index = selectedCellIndex else {
            print("Tried to get color without selecting any module.")
            return nil
        }
        
        return builder.getModule(at: index)?.selectedColor
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
}
