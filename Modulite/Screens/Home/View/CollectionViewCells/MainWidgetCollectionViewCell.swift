//
//  MainWidgetCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import SnapKit

class MainWidgetCollectionViewCell: UICollectionViewCell {
    static let reuseId = "MainWidgetCollectionViewCell"
    
    // MARK: - Properties
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    private(set) lazy var widgetImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        return view
    }()
    
    private(set) lazy var widgetNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(textStyle: .callout, weight: .semibold)
        view.textColor = .systemGray
        view.textAlignment = .center
        
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
    func configure(image: UIImage?, name: String?) {
        widgetImageView.image = image
        widgetNameLabel.text = name
    }
    
    private func addSubviews() {
        addSubview(widgetImageView)
        addSubview(widgetNameLabel)
    }
    
    private func setupConstraints() {
        widgetImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().offset(-38)
        }
        
        widgetNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(widgetImageView.snp.bottom).offset(16)
        }
    }
}
