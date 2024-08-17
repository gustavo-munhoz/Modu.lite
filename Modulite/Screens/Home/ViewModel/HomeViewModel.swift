//
//  HomeViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import Combine

protocol HomeNavigationFlowDelegate: AnyObject {
    func navigateToWidgetSetup(forWidgetId id: UUID)
}

class HomeViewModel: NSObject {
    
    weak var delegate: HomeNavigationFlowDelegate?
    
    @Published var mainWidgets: [UIImage] = [
        UIImage(systemName: "gear")!,
        UIImage(systemName: "gear")!,
        UIImage(systemName: "gear")!
    ]
    
    @Published var auxiliaryWidgets: [UIImage] = [
        UIImage(systemName: "trash.fill")!,
        UIImage(systemName: "trash.fill")!
    ]
    
    @Published var tips: [UIImage] = []
    
    func startWidgetSetupFlow(for id: UUID? = nil) {
        delegate?.navigateToWidgetSetup(forWidgetId: id ?? UUID())
    }
}
