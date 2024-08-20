//
//  WidgetEditorViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import Foundation

class WidgetEditorViewModel: NSObject {
    
    private(set) var widgetId: UUID!
    
    private(set) weak var delegate: HomeNavigationFlowDelegate?
    
    // MARK: - Setters
    func setDelegate(to delegate: HomeNavigationFlowDelegate) {
        self.delegate = delegate
    }
    
    func setWidgetId(to id: UUID) {
        self.widgetId = id
    }
    
}
