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
    
    // MARK: - Properties
    private let createBlockingSessionView = BlockingSessionView()
    var viewModel = BlockingSessionViewModel()
    weak var delegate: BlockingSessionViewControllerDelegate?
    
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
        createBlockingSessionView.updateSessionTitle(viewModel.getName())
        createBlockingSessionView.setIsAllDay(viewModel.getIsAllDay())
        createBlockingSessionView.setStartTime(viewModel.getStartsAt())
        createBlockingSessionView.setEndTime(viewModel.getEndsAt())
        createBlockingSessionView.setSelectedDays(viewModel.getDaysOfWeek())
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
            print("Nenhum aplicativo selecionado")
            return
        }

        let weekDays = viewModel.getDaysOfWeek()
        let startTime = viewModel.getStartsAt()
        let endTime = viewModel.getEndsAt()
        
        guard let startHour = startTime.hour,
              let startMinute = startTime.minute,
              let endHour = endTime.hour,
              let endMinute = endTime.minute else {
            print("Horários inválidos")
            return
        }

        let appBlockManager = AppBlockManager(
            selection: viewModel.getActivitySelection(),
            activityName: DeviceActivityName(viewModel.getName()),
            weekDays: weekDays,
            startHour: startHour,
            startMinute: startMinute,
            endHour: endHour,
            endMinute: endMinute
        )

        if isEditingSession, let session = currentSession {
            session.name = viewModel.getName()
            session.updateSelection(viewModel.activitySelection)
            session.blockingType = viewModel.getBlockingType()
            session.isAllDay = viewModel.getIsAllDay()
            session.startsAt = startTime
            session.endsAt = endTime
            session.daysOfWeek = weekDays
            session.isActive = false
            
            delegate?.createBlockingSessionViewController(self, didCreate: session)
            dismiss(animated: true, completion: nil)
            return
        }

        let newBlockingSession = createSession(
            name: viewModel.getName(),
            selection: viewModel.getActivitySelection(),
            blockingType: viewModel.getBlockingType(),
            isAllDay: viewModel.getIsAllDay(),
            startsAt: startTime,
            endsAt: endTime,
            daysOfWeek: weekDays
        )
        
        delegate?.createBlockingSessionViewController(self, didCreate: newBlockingSession)
        dismiss(animated: true, completion: nil)
    }
    
    func createSession(
        name: String,
        selection: FamilyActivitySelection,
        blockingType: BlockType,
        isAllDay: Bool,
        startsAt: DateComponents,
        endsAt: DateComponents,
        daysOfWeek: [WeekDay]
    ) -> AppBlockingSession {
        
        return AppBlockingSession(
            name: name,
            selection: selection,
            blockingType: blockingType,
            isAllDay: isAllDay,
            startsAt: startsAt,
            endsAt: endsAt
        )
    }


    @objc private func presentSelectApps() {
        let appBlockManager = AppBlockManager(
            selection: viewModel.activitySelection,
            activityName: DeviceActivityName(viewModel.getName()),
            weekDays: viewModel.getDaysOfWeek(),
            startHour: viewModel.getStartsAt().hour ?? 0,
            startMinute: viewModel.getStartsAt().minute ?? 0,
            endHour: viewModel.getEndsAt().hour ?? 23,
            endMinute: viewModel.getEndsAt().minute ?? 59
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
