//
//  SelectAppsCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit

class SelectAppsCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    unowned let selectAppsViewControllerDelegate: SelectAppsViewControllerDelegate
    let selectedApps: [AppInfo]
    
    init(delegate: SelectAppsViewControllerDelegate, selectedApps: [AppInfo], router: Router) {
        selectAppsViewControllerDelegate = delegate
        self.router = router
        self.selectedApps = selectedApps
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let viewController = SelectAppsViewController.instantiate(
            with: selectAppsViewControllerDelegate,
            selectedApps: selectedApps
        )
        
        router.present(viewController, animated: animated, onDismiss: onDismiss)
    }
}
