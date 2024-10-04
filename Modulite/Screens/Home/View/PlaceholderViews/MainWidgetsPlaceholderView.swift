//
//  MainWidgetsPlaceholderView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/10/24.
//

import UIKit
import SnapKit

class MainWidgetsPlaceholderView: UIView {
    
    // MARK: - Properties
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(textStyle: .title3, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = .localized(for: .homeViewMainWidgetsPlaceholderTitle)
        
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, symbolicTraits: .traitItalic)
        label.textColor = .systemGray
        label.textAlignment = .center
        
        let text1 = NSAttributedString(
            string: .localized(for: .homeViewMainWidgetsPlaceholderSubtitle1),
            attributes: [
                .font: label.font as Any,
                .foregroundColor: label.textColor as Any
            ]
        )
                
        let plusIcon = UIImage(systemName: "plus.circle")?
            .withTintColor(
                .systemGray,
                renderingMode: .alwaysOriginal
            )
            .withConfiguration(
                UIImage.SymbolConfiguration.init(weight: .bold)
            )
        
        let attachment = NSTextAttachment()
        attachment.image = plusIcon
        
        let iconFontHeight = label.font.capHeight
        let iconSizeMultiplier: CGFloat = 1.75
        let iconSize = iconFontHeight * iconSizeMultiplier
        let verticalOffset = (label.font.capHeight - iconSize) / 2

        attachment.bounds = CGRect(
            x: 0,
            y: verticalOffset,
            width: iconSize,
            height: iconSize
        )
        
        let iconString = NSAttributedString(attachment: attachment)
                
        let text2 = NSAttributedString(
            string: .localized(for: .homeViewMainWidgetsPlaceholderSubtitle2),
            attributes: [
                .font: label.font as Any,
                .foregroundColor: label.textColor as Any
            ]
        )
                
        let combinedString = NSMutableAttributedString()
        combinedString.append(text1)
        combinedString.append(NSAttributedString(" "))
        combinedString.append(iconString)
        combinedString.append(NSAttributedString(" "))
        combinedString.append(text2)
                
        label.attributedText = combinedString
        
        return label
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
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.left.right.equalToSuperview()
            make.bottom.equalTo(snp.centerY)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
