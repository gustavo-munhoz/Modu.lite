//
//  WidgetLayoutCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 20/08/24.
//

import UIKit

class WidgetLayoutCell: UICollectionViewCell {
    static let reuseId = "WidgetLayoutCell"
    
    private(set) lazy var image: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "house.fill"))
        
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
        addSubview(image)
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
