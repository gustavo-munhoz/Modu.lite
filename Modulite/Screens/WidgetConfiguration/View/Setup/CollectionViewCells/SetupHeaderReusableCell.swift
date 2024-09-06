//
//  SetupHeaderReusableCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import SnapKit
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
    
    func setup(
        title: String
    ) {
        backgroundColor = .whiteTurnip
        titleLabel.attributedText = CustomizedTextFactory.createTextWithAsterisk(with: title)
        
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
}
