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
    var viewModel = CreateSessionViewModel()
    weak var delegate: BlockingSessionViewControllerDelegate?
    
    override func loadView() {
        self.view = createBlockingSessionView
        
        //FIXME: - Remove viewmodel
        createBlockingSessionView.viewModel = viewModel
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
            self?.viewModel.activitySelection = apps
        }
        createBlockingSessionView.onSelectApps = { [weak self] in
            self?.presentSelectApps()
        }
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveBlockingSession() {
        guard viewModel.activitySelection
            .applications
            .isEmpty == false ||
                viewModel.activitySelection
            .categories
            .isEmpty == false else {
            print("Any app selected")
            return
        }

        let newBlockingSession = AppBlockingSession(
            name: viewModel.getName(),
            selection: viewModel.getActivitySelection(),
            blockingType: viewModel.getBlockingType(),
            isAllDay: viewModel.getIsAllDay(),
            startsAt: viewModel.getStartsAt(),
            endsAt: viewModel.getEndsAt(),
            daysOfWeek: viewModel.getDaysOfWeek(),
            isActive: viewModel.getIsActive()
        )
        
        delegate?.createBlockingSessionViewController(
            self,
            didCreate: newBlockingSession
        )

        dismiss(animated: true, completion: nil)
    }

    @objc private func presentSelectApps() {
        // Inicializa o AppBlockManager com uma seleção vazia ou existente
        let appBlockManager = AppBlockManager(
            selection: viewModel.activitySelection,
            activityName: DeviceActivityName(""),
            schedule: DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0),
                intervalEnd: DateComponents(hour: 23, minute: 59),
                repeats: true
            )
        )
        
        let selectAppsView = ScreenTimeSelectAppsContentView(
            model: appBlockManager,
            onComplete: {
                self.viewModel.activitySelection = appBlockManager.activitySelection
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
