//
//  ComingSoonCircularIconView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 10/10/24.
//

import UIKit
import SnapKit

class ComingSoonCircularIconView: UIView {
    
    private(set) lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.preferredSymbolConfiguration = .init(pointSize: 60)
        
        return view
    }()
        
    private lazy var circleView: UIView = {
        let view = UIView()
        
        view.layer.borderWidth = 3.0
        view.layer.cornerRadius = 67/2
        view.layer.masksToBounds = true
        
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setup(with image: UIImage, color: UIColor) {
        iconImageView.image = image
        circleView.layer.borderColor = color.cgColor
    }
        
    private func setupViews() {
        addSubview(circleView)
        addSubview(iconImageView)
        
        circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(67)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(circleView)
            make.height.equalTo(32)
        }
    }
}
