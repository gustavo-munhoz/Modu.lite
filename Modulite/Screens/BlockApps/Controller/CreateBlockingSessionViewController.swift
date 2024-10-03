//
//  CreateBlockingSessionViewController.swift
//  Modulite
//
//  Created by André Wozniack on 01/10/24.
//

import UIKit
import SwiftUI
import ManagedSettings
import FamilyControls
import DeviceActivity

protocol BlockingSessionViewControllerDelegate: AnyObject {
    func createBlockingSessionViewController(
        _ viewController: CreateBlockingSessionViewController,
        didCreate session: AppBlockingSession
    )
}

class CreateBlockingSessionViewController: UIViewController {
    
    private let createBlockingSessionView = CreateNewBlockingSessionView()
    var blockingSessionViewModel = CreateSessionViewModel()
    weak var delegate: BlockingSessionViewControllerDelegate?
    
    override func loadView() {
        self.view = createBlockingSessionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCallbacks()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(dismissModal)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveBlockingSession)
        )
        
        title = "Create Blocking Session"
    }
    
    private func setupCallbacks() {
        createBlockingSessionView.onAppsSelected = { [weak self] apps in
            self?.blockingSessionViewModel.activitySelection = apps
        }
        createBlockingSessionView.onSelectApps = { [weak self] in
            self?.presentSelectApps()
        }
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveBlockingSession() {
        guard blockingSessionViewModel.activitySelection
            .applications
            .isEmpty == false ||
                blockingSessionViewModel.activitySelection
            .categories
            .isEmpty == false else {
            print("Any app selected")
            return
        }

        let newBlockingSession = AppBlockingSession(
            name: blockingSessionViewModel.name,
            selection: blockingSessionViewModel.activitySelection,
            blockingType: blockingSessionViewModel.blockingType,
            isAllDay: blockingSessionViewModel.isAllDay,
            startsAt: blockingSessionViewModel.startsAt,
            endsAt: blockingSessionViewModel.endsAt,
            daysOfWeek: blockingSessionViewModel.daysOfWeek,
            isActive: blockingSessionViewModel.isActive
        )
        
        delegate?.createBlockingSessionViewController(
            self,
            didCreate: newBlockingSession
        )

        dismiss(animated: true, completion: nil)
    }

    @objc private func presentSelectApps() {
        let selectAppsView = ScreenTimeSelectAppsContentView(
            model: FamilyControlsManager(),
            onComplete: {
                self.blockingSessionViewModel.activitySelection = FamilyControlsManager.shared.activitySelection
                self.dismiss(animated: true, completion: nil)
            },
            onCancel: {
                self.dismiss(animated: true, completion: nil)
            }
        )

        let hostingController = UIHostingController(rootView: selectAppsView)
        present(hostingController, animated: true, completion: nil)
    }
}

extension CreateBlockingSessionViewController {
    static func instantiate(
        with delegate: BlockingSessionViewControllerDelegate
    ) -> CreateBlockingSessionViewController {
        let vc = CreateBlockingSessionViewController()
        vc.delegate = delegate
        
        return vc
    }
}

extension CreateBlockingSessionViewController: ScreenTimeSelectAppsContentViewDelegate {
    func screenTimeSelectAppsContentView(
        _ view: ScreenTimeSelectAppsContentView,
        didSelect activitySelection: FamilyActivitySelection
    ) {
        // viewModel.setActivitySelection(activitySelection)
    }
    
    
}
