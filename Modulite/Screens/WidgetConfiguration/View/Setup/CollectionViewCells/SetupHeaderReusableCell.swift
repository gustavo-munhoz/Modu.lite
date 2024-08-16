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
    
    private(set) lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = .localized(for: .setupHeaderSearchBarPlaceholder)
        
        
        return view
    }()
    
    // MARK: - Setup methods
    
    func setup(title: String, containsSearchBar: Bool = false) {
        backgroundColor = .screenBackground
        titleLabel.attributedText = createTextWithAsterisk(with: title)
        
        addSubviews(containsSearchBar: containsSearchBar)
        setupConstraints(containsSearchBar: containsSearchBar)
    }
    
    private func addSubviews(containsSearchBar: Bool) {
        addSubview(titleLabel)
        
        if containsSearchBar {
            addSubview(searchBar)
        }
    }
    
    private func setupConstraints(containsSearchBar: Bool) {
        if containsSearchBar {
            titleLabel.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
            }
            
            searchBar.snp.makeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.height.equalTo(37)
            }
            
        } else {
            titleLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
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
