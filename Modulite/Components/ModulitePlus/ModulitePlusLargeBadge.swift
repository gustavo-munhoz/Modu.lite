//
//  ModulitePlusLargeBadge.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/10/24.
//

import UIKit
import SnapKit

class ModulitePlusLargeBadge: UIView {
    
    // MARK: - Properties
    private(set) lazy var moduliteImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "moduliteAppName")!)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
        
    let plusBadge = ModulitePlusSmallBadge()
    
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
        addSubview(moduliteImage)
        addSubview(plusBadge)
    }
    
    private func setupConstraints() {
        moduliteImage.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(25)
        }
        
        plusBadge.snp.makeConstraints { make in
            make.left.equalTo(moduliteImage.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(31)
        }
    }
}
