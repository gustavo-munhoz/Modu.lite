//
//  HomeViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import Combine

class HomeViewModel: NSObject {
    
    weak var delegate: HomeNavigationFlowDelegate?
    
    @Published var mainWidgets: [ModuliteWidgetConfiguration]
    
    @Published var auxiliaryWidgets: [UIImage] = [
        UIImage(systemName: "trash.fill")!,
        UIImage(systemName: "trash.fill")!
    ]
    
    @Published var tips: [UIImage] = []
    
    override init() {
        let persistedWidgets = CoreDataPersistenceController.shared.fetchWidgets()
        mainWidgets = persistedWidgets.map {
            ModuliteWidgetConfiguration(persistedConfiguration: $0)
        }
        super.init()
    }
    
    func startWidgetSetupFlow(for id: UUID? = nil) {
        delegate?.navigateToWidgetSetup(forWidgetId: id ?? UUID())
    }
}
