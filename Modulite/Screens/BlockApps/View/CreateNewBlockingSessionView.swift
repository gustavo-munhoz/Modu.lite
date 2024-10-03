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
    
    // MARK: - Subviews
    
    private lazy var sessionTitleLabel: UITextField = {
        let textField = UITextField()
        textField.text = "Blocking session #1"
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .potatoYellow
        return textField
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    // Botão para escolher apps
    private lazy var chooseAppsLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: .blockingSessionChooseAppsToBlock)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var searchAppsButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle(
            .localized(for: .blockingSessionButtonSearchApps),
            for: .normal
        )
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(presentSelectApps), for: .touchUpInside)
        return button
    }()
    
    // Seção de duração e condições
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "Select duration and conditions"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var scheduledButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Scheduled", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var alwaysOnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Always on", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemOrange.cgColor
        return button
    }()
    
    // Switch para All Day
    private lazy var allDaySwitch: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()
    
    private lazy var allDayLabel: UILabel = {
        let label = UILabel()
        label.text = "All day"
        return label
    }()
    
    // Seletor de horário de início e fim
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Start at"
        return label
    }()
    
    private lazy var startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        return picker
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Finishes at"
        return label
    }()
    
    private lazy var endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        return picker
    }()
    
    // Dias da semana
    private lazy var daysOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var dayButtons: [UIButton] = {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        return days.map { day in
            let button = UIButton(type: .system)
            button.setTitle(day, for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.carrotOrange.cgColor
            return button
        }
    }()
    
    // Botão para salvar sessão
    private lazy var saveSessionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE SESSION", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .fiestaGreen
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        backgroundColor = .whiteTurnip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func addSubviews() {
        addSubview(sessionTitleLabel)
        addSubview(editButton)
        addSubview(chooseAppsLabel)
        addSubview(searchAppsButton)
        addSubview(durationLabel)
        addSubview(scheduledButton)
        addSubview(alwaysOnButton)
        addSubview(allDaySwitch)
        addSubview(allDayLabel)
        addSubview(startTimeLabel)
        addSubview(startTimePicker)
        addSubview(endTimeLabel)
        addSubview(endTimePicker)
        addSubview(daysOfWeekStackView)
        addSubview(saveSessionButton)
        
        // Adicionar botões de dias da semana no stackView
        dayButtons.forEach { daysOfWeekStackView.addArrangedSubview($0) }
    }
    
    // MARK: - Setup Constraints using SnapKit
    private func setupConstraints() {
        // Título da sessão e botão de editar
        setupConstraintsTittleEditButton()
        
        // Escolher apps
        setupContraintsChosseApps()
        
        // Duração e condições
        setupConstatinstsDurationConditions()
        setupConstraintsAllDay()
        setupConstraintsTime()
        
        // Dias da semana
        setupConstraintsDaysOfWeek()
        
        // Botão de salvar sessão
        setupConstraintsSaveButton()
    }
    private func setupConstraintsTittleEditButton() {
        sessionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(sessionTitleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    private func setupContraintsChosseApps() {
        chooseAppsLabel.snp.makeConstraints { make in
            make.top.equalTo(sessionTitleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        searchAppsButton.snp.makeConstraints { make in
            make.top.equalTo(chooseAppsLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    private func setupConstatinstsDurationConditions() {
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(searchAppsButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        scheduledButton.snp.makeConstraints { make in
            make.top.equalTo(durationLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        alwaysOnButton.snp.makeConstraints { make in
            make.centerY.equalTo(scheduledButton)
            make.leading.equalTo(scheduledButton.snp.trailing).offset(10)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    private func setupConstraintsAllDay() {
        // All Day Switch
        allDayLabel.snp.makeConstraints { make in
            make.top.equalTo(scheduledButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        allDaySwitch.snp.makeConstraints { make in
            make.centerY.equalTo(allDayLabel)
            make.leading.equalTo(allDayLabel.snp.trailing).offset(10)
        }
    }
    private func setupConstraintsTime() {
        // Horários de início e fim
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
    }
    private func setupConstraintsDaysOfWeek() {
        daysOfWeekStackView.snp.makeConstraints { make in
            make.top.equalTo(endTimePicker.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    private func setupConstraintsSaveButton() {
        saveSessionButton.snp.makeConstraints { make in
            make.top.equalTo(daysOfWeekStackView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func presentSelectApps() {
        onSelectApps?()
    }
    
    @objc private func handleEditButtonTap() {
        sessionTitleLabel.becomeFirstResponder()
    }
    
}
