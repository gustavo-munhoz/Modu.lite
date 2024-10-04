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

class CreateNewBlockingSessionView: UIView {
    
    // MARK: - Callback
    var onAppsSelected: ((FamilyActivitySelection) -> Void)?
    var onSelectApps: (() -> Void)?
    
    // Propriedade para armazenar a view model
    var viewModel: CreateSessionViewModel?
    
    // MARK: - Subviews
    
    private lazy var sessionTitleTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Blocking session #1"
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .potatoYellow
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
    
    // MARK: - Setup Constraints using SnapKit
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
        viewModel?.setName(sessionTitleTextField.text ?? "")
    }
    
    @objc private func presentSelectApps() {
        onSelectApps?()
    }
    
    @objc private func allDaySwitchToggled() {
        viewModel?.setIsAllDay(allDaySwitch.isOn)
    }
    
    @objc private func startTimeChanged() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: startTimePicker.date)
        viewModel?.setStartsAt(components)
    }
    
    @objc private func endTimeChanged() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: endTimePicker.date)
        viewModel?.setEndsAt(components)
    }
    
    @objc private func dayButtonTapped(sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        guard let dayIndex = ["M", "T", "W", "T", "F", "S", "S"].firstIndex(of: title) else { return }
        if sender.backgroundColor == .clear {
            sender.backgroundColor = .carrotOrange
            viewModel?.appendDayOfWeek(WeekDay(rawValue: dayIndex)!)
        } else {
            sender.backgroundColor = .clear
            viewModel?.removeDayOfWeek(WeekDay(rawValue: dayIndex)!)
        }
    }
    
    @objc private func saveSessionTapped() {
        viewModel?.setIsActive(true)
    }
}
