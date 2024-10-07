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
        _ viewController: NewBlockingSessionViewController,
        didCreate session: AppBlockingSession
    )
}

class NewBlockingSessionViewController: UIViewController {
    
    private let createBlockingSessionView = NewBlockingSessionView()
    var viewModel = CreateSessionViewModel()
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

extension NewBlockingSessionViewController {
    static func instantiate(
        with delegate: BlockingSessionViewControllerDelegate
    ) -> NewBlockingSessionViewController {
        let vc = NewBlockingSessionViewController()
        vc.delegate = delegate
        return vc
    }
}

extension NewBlockingSessionViewController: ScreenTimeSelectAppsContentViewDelegate {
    func screenTimeSelectAppsContentView(
        _ view: ScreenTimeSelectAppsContentView,
        didSelect activitySelection: FamilyActivitySelection
    ) {
         viewModel.setActivitySelection(activitySelection)
    }
}

extension NewBlockingSessionViewController: NewBlockingSessionViewDelegate {
    func didUpdateSessionTitle(_ title: String) {
        viewModel.setName(title)
    }
    
    func didToggleAllDaySwitch(_ isAllDay: Bool) {
        viewModel.setIsAllDay(isAllDay)
    }
    
    func didUpdateStartTime(_ startTime: DateComponents) {
        viewModel.setStartsAt(startTime)
    }
    
    func didUpdateEndTime(_ endTime: DateComponents) {
        viewModel.setEndsAt(endTime)
    }
    
    func didUpdateSelectedDay(_ day: WeekDay, isSelected: Bool) {
        if isSelected {
            viewModel.appendDayOfWeek(day)
        } else {
            viewModel.removeDayOfWeek(day)
        }
    }
    
    func didTapSaveSession() {
        saveBlockingSession()
    }
}
