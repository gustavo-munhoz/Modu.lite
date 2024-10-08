//
//  SeparatorView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit
import SnapKit

class SeparatorView: UIView {
    
    // MARK: - Initializer
    init(backgroundColor: UIColor = .potatoYellow) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Method
    private func setupView() {
        snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }
}
