//
//  SkinUnlockBadge.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import UIKit
import SnapKit

class SkinUnlockBadge: UIView {
    
    // MARK: - Properties
    private(set) lazy var unlockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textColor = .black
        label.text = .localized(for: BadgeLocalizedTexts.skinUnlockFor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.text = .localized(for: BadgeLocalizedTexts.skin099)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unlockBadge = SkinUnlockSmallBadge()
    
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
        addSubview(unlockBadge)
        addSubview(unlockLabel)
        addSubview(priceLabel)

    }
    
    private func setupConstraints() {
        unlockBadge.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(84)
            make.height.equalTo(40)
        }
        
        snp.makeConstraints { make in
            make.width.equalTo(84)
            make.height.equalTo(40)
        }
        
        unlockLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().offset(14)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(unlockLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
}

class SkinUnlockSmallBadge: GradientLabelView {
    convenience init() {
        self.init(
            gradient: .ambrosia(),
            insets: .init(vertical: 5, horizontal: 5)
        )
        
        textAlignment = .center
        layer.cornerRadius = 6.25
        clipsToBounds = true
    }
}
