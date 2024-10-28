//
//  AppBlockingSessionHeader.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/10/24.
//

import UIKit
import SnapKit

class AppBlockingSessionHeader: HomeHeaderReusableCell {
    
    private let separator = SeparatorView()
    
    private var didAddSeparator: Bool = false
    
    func setup(
        title: String,
        hasButton: Bool,
        buttonAction: @escaping () -> Void = {},
        countValues: (current: Int, max: Int)? = nil
    ) {
        setup(
            title: title,
            buttonImage: hasButton ? UIImage(systemName: "plus.circle") : nil,
            buttonAction: buttonAction,
            countValues: countValues
        )
        
        if didAddSeparator { return }
        
        didAddSeparator = true
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
                
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(16)
            make.left.equalToSuperview()
        }
        
        actionButton.snp.remakeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(16)
            make.right.equalToSuperview()
        }
    }
}
