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
    
    private let selectedApps: [UIImage] = Array(repeating: UIImage(systemName: "house.fill")!, count: 6)
    
    @Published private(set) var displayedApps: [UIImage]
    
    override init() {
        displayedApps = selectedApps
    }
    
    // MARK: - Setters
    func setDelegate(to delegate: HomeNavigationFlowDelegate) {
        self.delegate = delegate
    }
    
    func setWidgetId(to id: UUID) {
        self.widgetId = id
    }
    
    // MARK: - Actions
    func insertCell(_ image: UIImage, at index: Int) {
        displayedApps.insert(image, at: index)
    }
    
    func removeCell(at index: Int) {
        displayedApps.remove(at: index)
    }
}
