//
//  HeaderView.swift
//  Modulite
//
//  Created by André Wozniack on 09/09/24.
//

import UIKit
import SnapKit

class AppBlockingHeaderView: UIView {
    
    // MARK: - Properties
    
    var onInfoButtonPressed: (() -> Void)?
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .textPrimary
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.adjustsFontSizeToFitWidth = true
    
        return view
    }()
    
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
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.left.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
    }
}
