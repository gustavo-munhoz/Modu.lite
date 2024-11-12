//
//  SelectAppsCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit
import WidgetStyling

class SelectAppsCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    unowned let selectAppsViewControllerDelegate: SelectAppsViewControllerDelegate
    let selectedApps: [AppData]
    let maxApps: Int
    
    init(
        delegate: SelectAppsViewControllerDelegate,
        selectedApps: [AppData],
        maxApps: Int,
        router: Router
    ) {
        selectAppsViewControllerDelegate = delegate
        self.router = router
        self.selectedApps = selectedApps
        self.maxApps = maxApps
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = SelectAppsViewController.instantiate(
            with: selectAppsViewControllerDelegate,
            selectedApps: selectedApps,
            maxApps: maxApps
        )
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}
