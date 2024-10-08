//
//  CreateNewBlockingSessionView.swift
//  Modulite
//
//  Created by André Wozniack on 30/09/24.
//

import UIKit
import SnapKit
import SwiftUI
import FamilyControls
import ManagedSettings

protocol NewBlockingSessionViewDelegate: AnyObject {
    func didUpdateSessionTitle(_ title: String)
    func didToggleAllDaySwitch(_ isAllDay: Bool)
    func didUpdateStartTime(_ startTime: DateComponents)
    func didUpdateEndTime(_ endTime: DateComponents)
    func didUpdateSelectedDay(_ day: WeekDay, isSelected: Bool)
    func didTapSaveSession()
    func saveData(
        title: String,
        isAllDay: Bool,
        startTime: DateComponents,
        endTime: DateComponents,
        selectedDays: [WeekDay: Bool]
    )
}

class BlockingSessionView: UIView {
    
    // MARK: - Callback
    var onSelectApps: (() -> Void)?
    
    // MARK: - Delegate
    weak var delegate: NewBlockingSessionViewDelegate?
    
    // MARK: - Subviews
    private lazy var sessionTitleTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Blocking session #1"
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .potatoYellow
        textField.returnKeyType = .done
        textField.delegate = self
        textField.addTarget(self, action: #selector(sessionTitleChanged), for: .editingChanged)
        return textField
    }()

    private lazy var searchAppsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search Apps", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(presentSelectApps), for: .touchUpInside)
        return button
    }()
    
    // Switch para All Day
    private lazy var allDaySwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.addTarget(self, action: #selector(allDaySwitchToggled), for: .valueChanged)
        return switchControl
    }()
    
    private lazy var allDayLabel: UILabel = {
        let label = UILabel()
        label.text = "All Day"
        return label
    }()
    
    // Seletor de horário de início e fim
    private lazy var startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(startTimeChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(endTimeChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Time"
        return label
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "End Time"
        return label
    }()
    
    // Dias da semana
    private lazy var dayButtons: [UIButton] = {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        return days.map { day in
            let button = UIButton(type: .system)
            button.setTitle(day, for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.carrotOrange.cgColor
            button.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
            return button
        }
    }()
    
    private lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: dayButtons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var saveSessionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE SESSION", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .fiestaGreen
        button.addTarget(self, action: #selector(saveSessionTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupGestureToDismissKeyboard()
        backgroundColor = .whiteTurnip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupSubviews() {
        addSubview(sessionTitleTextField)
        addSubview(searchAppsButton)
        addSubview(allDayLabel)
        addSubview(allDaySwitch)
        addSubview(startTimeLabel)
        addSubview(startTimePicker)
        addSubview(endTimeLabel)
        addSubview(endTimePicker)
        addSubview(dayOfWeekStackView)
        addSubview(saveSessionButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        sessionTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        searchAppsButton.snp.makeConstraints { make in
            make.top.equalTo(sessionTitleTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        allDayLabel.snp.makeConstraints { make in
            make.top.equalTo(searchAppsButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        allDaySwitch.snp.makeConstraints { make in
            make.centerY.equalTo(allDayLabel)
            make.leading.equalTo(allDayLabel.snp.trailing).offset(10)
        }
        
        startTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(allDayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        startTimePicker.snp.makeConstraints { make in
            make.top.equalTo(startTimeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        endTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(startTimePicker.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        endTimePicker.snp.makeConstraints { make in
            make.top.equalTo(endTimeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        dayOfWeekStackView.snp.makeConstraints { make in
            make.top.equalTo(endTimePicker.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        saveSessionButton.snp.makeConstraints { make in
            make.top.equalTo(dayOfWeekStackView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func sessionTitleChanged() {
        delegate?.didUpdateSessionTitle(sessionTitleTextField.text ?? "")
    }
    
    @objc private func presentSelectApps() {
        onSelectApps?()
    }
    
    @objc private func allDaySwitchToggled() {
        delegate?.didToggleAllDaySwitch(allDaySwitch.isOn)
    }
    
    @objc private func startTimeChanged() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: startTimePicker.date)
        delegate?.didUpdateStartTime(components)
    }
    
    @objc private func endTimeChanged() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: endTimePicker.date)
        delegate?.didUpdateEndTime(components)
    }
    
    @objc private func dayButtonTapped(sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        guard let dayIndex = ["M", "T", "W", "T", "F", "S", "S"].firstIndex(of: title) else { return }
        let weekDay = WeekDay(rawValue: dayIndex)!
        
        if sender.backgroundColor == .clear {
            sender.backgroundColor = .carrotOrange
            delegate?.didUpdateSelectedDay(weekDay, isSelected: true)
        } else {
            sender.backgroundColor = .clear
            delegate?.didUpdateSelectedDay(weekDay, isSelected: false)
        }
    }
    
    @objc private func saveSessionTapped() {
        delegate?.didTapSaveSession()
    }
    
    private func setupGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    // MARK: - Update Methods
    func updateSessionTitle(_ title: String) {
        sessionTitleTextField.text = title
    }
    func setIsAllDay(_ isAllDay: Bool) {
        allDaySwitch.isOn = isAllDay
    }
    func setStartTime(_ startTime: DateComponents) {
        if let date = Calendar.current.date(from: startTime) {
            startTimePicker.date = date
        }
    }
    func setEndTime(_ endTime: DateComponents) {
        if let date = Calendar.current.date(from: endTime) {
            endTimePicker.date = date
        }
    }
    func setSelectedDays(_ days: [WeekDay]) {
        for (index, button) in dayButtons.enumerated() {
            if days.contains(WeekDay(rawValue: index)!) {
                button.backgroundColor = .carrotOrange
            } else {
                button.backgroundColor = .clear
            }
        }
    }
}

extension BlockingSessionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
