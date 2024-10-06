//
//  EditorSectionHeader.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit

class EditorSectionHeader: UIView {
    
    // MARK: - Properties
    
    var onInfoButtonPressed: (() -> Void)?
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .textPrimary
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.adjustsFontSizeToFitWidth = true
    
        return view
    }()
    
    private(set) lazy var infoButton: UIButton = {
        let view = UIButton()
        // TODO: Fix image sizing
        view.setImage(UIImage(systemName: "info.circle")!, for: .normal)
            
        view.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    func setTitleForKey(_ key: String.LocalizedKey) {
        titleLabel.attributedText = CustomizedTextFactory.createTextWithAsterisk(
            with: .localized(for: key)
        )
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(infoButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.left.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
        
        infoButton.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    // MARK: - Actions
    @objc func infoButtonTapped() {
        onInfoButtonPressed?()
    }
}
