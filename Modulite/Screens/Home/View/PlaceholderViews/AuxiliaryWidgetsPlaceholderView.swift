//
//  AuxiliaryWidgetsPlaceholderView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/10/24.
//

import UIKit
import SnapKit

class AuxiliaryWidgetsPlaceholderView: UIView {
    
    // MARK: - Properties
    private(set) lazy var lockerIcon: UIImageView = {
        let image = UIImage(
            systemName: "lock"
        )?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    pointSize: 24,
                    weight: .regular
                )
            )
        
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(textStyle: .title3, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = .localized(for: .homeViewAuxiliaryWidgetsPlaceholderTitle)
        
        return label
    }()
    
    let plusLargeBadge = ModulitePlusLargeBadge()
    
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
        addSubview(lockerIcon)
        addSubview(titleLabel)
        addSubview(plusLargeBadge)
    }
    
    private func setupConstraints() {
        lockerIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(24)
            make.bottom.equalTo(snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.left.right.equalToSuperview()
            make.top.equalTo(lockerIcon.snp.bottom).offset(10)
        }
        
        plusLargeBadge.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalTo(250)
        }
    }
}
