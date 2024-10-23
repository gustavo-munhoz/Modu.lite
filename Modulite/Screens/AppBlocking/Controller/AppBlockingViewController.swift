//
//  AppBlockingViewController.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import UIKit
import SwiftUI
import FamilyControls

class AppBlockingViewController: UIViewController {
    
    private var appBlockingView = AppBlockingView()
    private var viewModel = AppBlockingViewModel()
    
    override func loadView() {
        view = appBlockingView
        view.backgroundColor = .white
        
        appBlockingView.onAddSession = { [weak self] in
            self?.presentSelectionView()
        }
        
        appBlockingView.onSwitchToggle = { [weak self] isOn in
            self?.handleSwitchToggle(isOn: isOn)
        }
    }
    
    private func presentSelectionView() {
        let initialSession = AppBlockingSession(
            sessionName: "Nova Sessão",
            activitySelection: FamilyActivitySelection(),
            isAllDay: true,
            isActive: false, blockManager: BlockManager(activityName: <#T##DeviceActivityName#>)
        )
        
        var selectionView = ScreenTimeSelectAppsContentView(model: initialSession)
        selectionView.delegate = self
        
        let hostingController = UIHostingController(rootView: selectionView)
        present(hostingController, animated: true, completion: nil)
    }
    
    private func handleSwitchToggle(isOn: Bool) {
        print("Switch is now: \(isOn ? "ON" : "OFF")")
        
        if isOn {
            viewModel.sessions.forEach { $0.blockManager.startBlock()}
        } else {
            viewModel.sessions.forEach { $0.blockManager.stopBlock()}
        }
    }
}

extension AppBlockingViewController: ScreenTimeSelectAppsContentViewDelegate {
    func screenTimeSelectAppsContentView(
        _ view: ScreenTimeSelectAppsContentView,
        didSelect activitySelection: FamilyActivitySelection
    ) {
        let newSession = AppBlockingSession(
            sessionName: "Bloqueio de Apps",
            activitySelection: activitySelection,
            isAllDay: true,
            isActive: true, blockManager: <#BlockManager#>
        )
        
        viewModel.sessions.append(newSession)
        dismiss(animated: true) {
            print("Nova sessão \(newSession.sessionName) criada com:")
            print("\(newSession.appsCount) apps;")
            print("\(newSession.categoriesCount) categories")
        }
    }
}
