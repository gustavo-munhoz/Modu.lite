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
}
