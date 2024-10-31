//
//  ImageWithLabelView.swift
//  Modulite
//
//  Created by André Wozniack on 31/10/24.
//

import UIKit
import SnapKit

class ImagePreviewCell: UICollectionViewCell {
    static let reuseId = "ImagePreviewCell"
    
    // MARK: - Subviews
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .whiteTurnip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(imageView)
        addSubview(textLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalTo(imageView)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    // MARK: - Configuration
    
    func configure(with image: UIImage?, text: String) {
        imageView.image = image
        textLabel.text = text
    }
}
