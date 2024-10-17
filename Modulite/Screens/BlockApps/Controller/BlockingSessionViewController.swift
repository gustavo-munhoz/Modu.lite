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
import Combine

protocol BlockingSessionViewControllerDelegate: AnyObject {
    func createBlockingSessionViewController(
        _ viewController: BlockingSessionViewController,
        didCreate session: AppBlockingSession
    )
}

class BlockingSessionViewController: UIViewController {
    
    // MARK: - Properties
    private let createBlockingSessionView = BlockingSessionView()
    var viewModel = BlockingSessionViewModel()
    weak var delegate: BlockingSessionViewControllerDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    private let userDefaultsKey = "ScreenTimeSelection"
    
    var isEditingSession = false
    var currentSession: AppBlockingSession?
    
    // MARK: - Init Methods
    override func loadView() {
        self.view = createBlockingSessionView
        createBlockingSessionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCallbacks()
        updateViewWithSessionData()
        
    }
    
    private func updateViewWithSessionData() {
        createBlockingSessionView.updateSessionTitle(viewModel.name)
        createBlockingSessionView.setIsAllDay(viewModel.isAllDay)
        createBlockingSessionView.setStartTime(viewModel.startsAt)
        createBlockingSessionView.setEndTime(viewModel.endsAt)
        createBlockingSessionView.setSelectedDays(viewModel.daysOfWeek)
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
    
    func saveSelection(selection: FamilyActivitySelection) {
    
        let defaults = UserDefaults.standard
        defaults.set(
            try? encoder.encode(selection),
            forKey: userDefaultsKey
        )
    }
    
    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: userDefaultsKey),
           let selection = try? decoder.decode(FamilyActivitySelection.self, from: data) {
            self.currentSession?.selection = selection
            return selection
            
        }
        return nil
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

        if isEditingSession, let session = currentSession {
            session.name = viewModel.name
            session.updateSelection(viewModel.activitySelection)
            session.blockingType = viewModel.blockingType
            session.isAllDay = viewModel.isAllDay
            session.startsAt = viewModel.startsAt
            session.endsAt = viewModel.endsAt
            session.daysOfWeek = viewModel.daysOfWeek
            session.isActive = false
            
            delegate?.createBlockingSessionViewController(self, didCreate: session)
            dismiss(animated: true, completion: nil)
            return
            
        }
        
        let newBlockingSession = AppBlockingSession(
            name: viewModel.name,
            selection: viewModel.activitySelection,
            blockingType: viewModel.blockingType,
            isAllDay: viewModel.isAllDay,
            startsAt: viewModel.startsAt,
            endsAt: viewModel.endsAt,
            daysOfWeek: viewModel.daysOfWeek
        )
        
        delegate?.createBlockingSessionViewController(self, didCreate: newBlockingSession)
        dismiss(animated: true, completion: nil)
    }

    @objc private func presentSelectApps() {
        let appBlockManager = AppBlockManager(
            selection: viewModel.activitySelection,
            activityName: DeviceActivityName(viewModel.name),
            schedule: DeviceActivitySchedule(
                intervalStart: viewModel.startsAt,
                intervalEnd: viewModel.endsAt,
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
    
    func saveData(
        title: String,
        isAllDay: Bool,
        startTime: DateComponents,
        endTime: DateComponents,
        selectedDays: [WeekDay: Bool]
    ) {
        viewModel.setName(title)
        viewModel.setIsAllDay(isAllDay)
        viewModel.setStartsAt(startTime)
        viewModel.setEndsAt(endTime)
    }
    
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
