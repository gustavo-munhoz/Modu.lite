//
//  BlockAppsCollectionViewCell.swift
//  Modulite
//
//  Created by André Wozniack on 05/09/24.
//

import UIKit
import SnapKit

protocol BlockAppsCellDelegate: AnyObject {
    func didToggleSwitch(at index: IndexPath, isActive: Bool)
}

class BlockAppsCollectionViewCell: UICollectionViewCell {
    static let reusId = "BlockAppsCollectionViewCell"
    
    weak var delegate: BlockAppsCellDelegate?
    var indexPath: IndexPath?
    
    var isActive: Bool = true {
        didSet {
            updateCellAppearance()
            toggleSwitch.setOn(isActive, animated: true) // Atualiza o switch
        }
    }
    
    private(set) lazy var toggleSwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        return view
    }()
    
    private(set) lazy var blockingSession: UILabel = {
        let label = UILabel()
        label.text = "Session"
        label.font = UIFont(textStyle: .title3, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00 - 23:59 | 6 days a week"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private(set) lazy var appsBlockedLabel: UILabel = {
        let label = UILabel()
        label.text = "13 apps blocked"
        label.font = UIFont(textStyle: .footnote, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.potatoYellow.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private(set) lazy var backgroundCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .fiestaGreen
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        updateCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(backgroundCard)
        contentView.addSubview(toggleSwitch)
        contentView.addSubview(blockingSession)
        contentView.addSubview(timeLabel)
        contentView.addSubview(appsBlockedLabel)
        contentView.addSubview(editButton)
    }
    
    private func setupConstraints() {
        backgroundCard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(22)
        }
        
        blockingSession.snp.makeConstraints { make in
            make.top.equalTo(toggleSwitch)
            make.left.equalTo(toggleSwitch.snp.right).offset(10)
        }
        
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-23)
            make.top.equalToSuperview().offset(22)
            make.height.width.equalTo(24)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(blockingSession.snp.bottom).offset(11)
            make.left.equalTo(toggleSwitch.snp.left)
        }
        
        appsBlockedLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.left.equalTo(toggleSwitch.snp.left)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
    
    private func updateCellAppearance() {
        if isActive {
            contentView.alpha = 1.0
            blockingSession.textColor = .black
            timeLabel.textColor = .darkGray
        } else {
            contentView.alpha = 0.5
            blockingSession.textColor = .gray
            timeLabel.textColor = .lightGray
        }
    }
    
    // Método chamado quando o toggle é alterado
    @objc private func toggleSwitched() {
        guard let indexPath = indexPath else { return }
        delegate?.didToggleSwitch(at: indexPath, isActive: toggleSwitch.isOn)
    }
}

