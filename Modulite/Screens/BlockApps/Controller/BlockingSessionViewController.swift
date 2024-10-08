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
        _ viewController: BlockingSessionViewController,
        didCreate session: AppBlockingSession
    )
}

class BlockingSessionViewController: UIViewController {
    
    private let createBlockingSessionView = BlockingSessionView()
    var viewModel = CreateSessionViewModel()
    weak var delegate: BlockingSessionViewControllerDelegate?
    
    override func loadView() {
        self.view = createBlockingSessionView
        createBlockingSessionView.delegate = self
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
            activityName: DeviceActivityName(viewModel.getName()),
            schedule: DeviceActivitySchedule(
                intervalStart: viewModel.getStartsAt(),
                intervalEnd: viewModel.getEndsAt(),
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

extension BlockingSessionViewController {
    static func instantiate(
        with delegate: BlockingSessionViewControllerDelegate
    ) -> BlockingSessionViewController {
        let vc = BlockingSessionViewController()
        vc.delegate = delegate
        return vc
    }
}

extension BlockingSessionViewController: ScreenTimeSelectAppsContentViewDelegate {
    func screenTimeSelectAppsContentView(
        _ view: ScreenTimeSelectAppsContentView,
        didSelect activitySelection: FamilyActivitySelection
    ) {
         viewModel.setActivitySelection(activitySelection)
    }
}

extension BlockingSessionViewController: NewBlockingSessionViewDelegate {
    func didUpdateSessionTitle(_ title: String) {
        print(title)
        viewModel.setName(title)
    }
    
    func didToggleAllDaySwitch(_ isAllDay: Bool) {
        print(isAllDay)
        viewModel.setIsAllDay(isAllDay)
    }
    
    func didUpdateStartTime(_ startTime: DateComponents) {
        print(startTime.hour ?? "")
        print(startTime.minute ?? "")
        viewModel.setStartsAt(startTime)
    }
    
    func didUpdateEndTime(_ endTime: DateComponents) {
        print(endTime.hour ?? "")
        print(endTime.minute ?? "")
        viewModel.setEndsAt(endTime)
    }
    
    func didUpdateSelectedDay(_ day: WeekDay, isSelected: Bool) {
        if isSelected {
            print(day)
            viewModel.appendDayOfWeek(day)
        } else {
            viewModel.removeDayOfWeek(day)
        }
    }
    
    func didTapSaveSession() {
        saveBlockingSession()
    }
}
