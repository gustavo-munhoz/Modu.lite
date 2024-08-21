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
    
    private let selectedApps: [UIImage] = Array(repeating: UIImage(systemName: "house.fill")!, count: 4)
    
    @Published private(set) var displayedApps: [UIImage?] = Array(repeating: nil, count: 6)
    
    override init() {
        super.init()
        
        for i in 0..<selectedApps.count {
            displayedApps[i] = selectedApps[i]
        }
    }
    
    // MARK: - Setters
    func setDelegate(to delegate: HomeNavigationFlowDelegate) {
        self.delegate = delegate
    }
    
    func setWidgetId(to id: UUID) {
        self.widgetId = id
    }
    
    // MARK: - Actions
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0, sourceIndex < displayedApps.count,
              destinationIndex >= 0, destinationIndex < displayedApps.count else {
            print("Invalid indices")
            return
        }

        let movingItem = displayedApps[sourceIndex]
        displayedApps.remove(at: sourceIndex)
        displayedApps.insert(movingItem, at: destinationIndex)
    }

//    func insertCell(_ image: UIImage, at index: Int) {
//        guard index >= 0 && index < 6 else {
//            fatalError("Tried to insert cell at invalid index: \(index)")
//        }
//        displayedApps[index] = image
//    }
//    
//    func removeCell(at index: Int) {
//        guard index >= 0 && index < 6 else {
//            fatalError("Tried to remove cell at invalid index: \(index)")
//        }
//        displayedApps[index] = nil
//    }
}
