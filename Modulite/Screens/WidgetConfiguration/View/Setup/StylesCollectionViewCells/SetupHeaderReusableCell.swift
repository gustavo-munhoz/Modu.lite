//
//  SetupHeaderReusableCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit

class SetupHeaderReusableCell: UICollectionViewCell {
    static let reuseId = "SetupHeaderReusableCell"
    
    // MARK: - Properties
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .textPrimary
        
        
        return view
    }()
    
    // MARK: - Setup methods
    
    func setup(title: String) {                
        titleLabel.attributedText = createTextWithAsterisk(with: title)
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Helper methods
    
    private func createTextWithAsterisk(with text: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment(
            image: UIImage(systemName: "asterisk")!
                .withTintColor(.appYellow, renderingMode: .alwaysOriginal)
        )
        
        imageAttachment.bounds = CGRect(x: 0, y: -2.5, width: 21, height: 21)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString("")
        
        completeText.append(attachmentString)
        completeText.append(NSAttributedString("  "))
        completeText.addAttributes(
            [.font: UIFont(textStyle: .title2, weight: .heavy)],
            range: NSMakeRange(0, 1)
        )
        
        let titleString = NSAttributedString(string: text, attributes: [
            .font: UIFont(textStyle: .title2, symbolicTraits: .traitBold.union(.traitItalic))!
        ])
        
        completeText.append(titleString)
        
        return completeText
    }
}
