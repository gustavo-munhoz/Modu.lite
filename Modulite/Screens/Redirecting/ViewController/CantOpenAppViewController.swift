//
//  CantOpenAppViewController.swift
//  Modulite
//
//  Created by André Wozniack on 05/11/24.
//

import UIKit
import SnapKit

class CantOpenAppViewController: UIViewController {
    
    private let containerView = UIView()
    private var alertView = CantOpenView()
    
    var onOkPressed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        alertView.onOkPressed = { [weak self] in
            self?.onOkPressed?()
            self?.dismiss(animated: false)
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(containerView)
        
        containerView.addSubview(alertView)
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
