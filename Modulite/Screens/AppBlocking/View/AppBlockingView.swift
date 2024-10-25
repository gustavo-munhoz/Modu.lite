//
//  AppBlockingView.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import UIKit

class AppBlockingView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
    }
    
    private func setupConstraints() {
        
    }
}
