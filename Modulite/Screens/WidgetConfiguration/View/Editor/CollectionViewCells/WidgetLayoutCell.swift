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
    
    private func addSubviews() {
        addSubview(image)
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

