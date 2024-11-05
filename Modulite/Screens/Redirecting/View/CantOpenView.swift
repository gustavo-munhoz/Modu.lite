//
//  CantOpenView.swift
//  Modulite
//
//  Created by André Wozniack on 05/11/24.
//

import UIKit
import SnapKit

class CantOpenView: UIView {
    
    // MARK: - Properties
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        
        view.attributedText = NSAttributedString(
            string: .localized(for: .redirectingAlertTitle),
            attributes: [
                .font: UIFont.spaceGrotesk(textStyle: .largeTitle, weight: .bold)
            ]
        )
        return view
    }()
    
    private(set) lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = -1
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        
        view.attributedText = CustomizedTextFactory.createFromMarkdown(
            with: .localized(for: .redirectingAlertMessage),
            fontSize: 16,
            alignment: .center
        )

        return view
    }()
    
    private(set) lazy var okButton: UIButton = {
        var config = ButtonFactory.mediumButton(
            titleKey: String.LocalizedKey.ok,
            backgroundColor: .blueberry
        )
        
        config.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        return config
    }()
    
    var onOkPressed: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .whiteTurnip
        layer.cornerRadius = 20
        
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(okButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(317)
            make.height.equalTo(266)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(27)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.top.equalTo(titleLabel).offset(40)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.width.equalTo(230)
        }
    }
    
    // MARK: - Actions
    @objc private func okButtonTapped() {
        onOkPressed?()
    }
}

#Preview {
    CantOpenView()
}
