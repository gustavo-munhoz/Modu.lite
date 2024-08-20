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
        titleLabel.attributedText = createTextWithAsterisk(with: .localized(for: key))
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
    
    // MARK: - Helper methods
    private func createTextWithAsterisk(with text: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment(
            image: UIImage(systemName: "asterisk")!
                .withTintColor(.lemonYellow, renderingMode: .alwaysOriginal)
        )
        
        imageAttachment.bounds = CGRect(x: 0, y: -2.5, width: 21, height: 21)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString("")
        
        completeText.append(attachmentString)
        completeText.append(NSAttributedString("  "))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 28
        paragraphStyle.firstLineHeadIndent = 0
        
        completeText.addAttributes(
            [.font: UIFont(textStyle: .title2, weight: .heavy)],
            range: NSRange(location: 0, length: 1)
        )
        
        let titleString = NSAttributedString(string: text, attributes: [
            .font: UIFont(textStyle: .title2, symbolicTraits: .traitBold.union(.traitItalic))!,
            .paragraphStyle: paragraphStyle
        ])
        
        completeText.append(titleString)
        completeText.addAttributes(
            [.paragraphStyle: paragraphStyle],
            range: NSRange(location: 0, length: completeText.length)
        )
        
        return completeText
    }
}
