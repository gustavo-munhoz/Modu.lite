//
//  HeaderReusableCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import SnapKit

class HeaderReusableCell: UICollectionViewCell {
    static let reuseId = "HeaderReusableCell"
    
    // MARK: - Properties
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2)
        let customFd = fd.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold
        ]])
        view.font = UIFont(descriptor: customFd, size: 0)
        view.textColor = .textPrimary
        
        return view
    }()
    
    private(set) lazy var actionButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Setup methods
    
    func setup(title: String) {
        addSubviews()
        setupContraints()
        
        titleLabel.text = title
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(actionButton)
    }
    
    private func setupContraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }
    }
}
