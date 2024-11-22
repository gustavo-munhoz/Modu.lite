//
//  MajorChangesView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import UIKit
import SnapKit

class MajorChangesView: UIView {
    
    var onGotItButtonPress: (() -> Void)?
    
    // MARK: - Subviews
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var warningImage: UIImageView = {
        let image = UIImage(
            systemName: "exclamationmark.triangle"
        )!
            .withTintColor(.carrotOrange, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: .init(64)))
        
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .extraLargeTitle, weight: .bold)
        label.textColor = .carrotOrange
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = .localized(for: MajorChangesLocalizedTexts.majorChangesTitle)
        
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = CustomizedTextFactory.createFromMarkdown(
            with: .localized(for: MajorChangesLocalizedTexts.majorChangesDescription),
            textStyle: .body
        )
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left

        return label
    }()
    
    private(set) lazy var dismissButton: UIButton = {
        let button = ButtonFactory.mediumButton(
            titleKey: String.LocalizedKey.gotIt
        )
        
        button.addTarget(
            self,
            action: #selector(didPressGotIt),
            for: .touchUpInside
        )
        
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func didPressGotIt() {
        onGotItButtonPress?()
    }
    
    // MARK: - Setup Methods
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(warningImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dismissButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        warningImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.height.equalTo(69)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(warningImage.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(64)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(48)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView).offset(-24)
        }
    }
}
