//
//  WidgetEmptyCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/08/24.
//

import UIKit

class WidgetEmptyCell: UICollectionViewCell {
    static let reuseId = "WidgetEmptyCell"
    
    // MARK: - Properties
    private(set) lazy var plusImage: UIImageView = {
        let image = UIImage(systemName: "plus.circle")!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
            .applyingSymbolConfiguration(.init(pointSize: 24, weight: .bold))
        
        let view = UIImageView(image: image)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    private func addSubviews() {
        addSubview(plusImage)
    }
    
    private func setupContraints() {
        plusImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
    }
}
