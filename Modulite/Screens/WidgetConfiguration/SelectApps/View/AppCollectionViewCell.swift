//
//  AppCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 06/09/24.
//

import UIKit
import SnapKit

class AppCollectionViewCell: UICollectionViewCell {
    static let reuseId = "AppCollectionViewCell"
    // MARK: - Properties
    
    private(set) lazy var selectedImageView: UIImageView = {
        let view = UIImageView(
            image: UIImage(systemName: "circle")!.withTintColor(
                .carrotOrange,
                renderingMode: .alwaysOriginal
            )
        )
        
        return view
    }()
    
    private(set) lazy var appNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    // MARK: - Setup methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with app: AppInfo, isSelected: Bool) {
        appNameLabel.text = app.name

        selectedImageView.setSymbolImage(
            getImageForState(selected: isSelected),
            contentTransition: .replace
        )
    }
    
    private func addSubviews() {
        addSubview(selectedImageView)
        addSubview(appNameLabel)
    }
    
    private func setupContraints() {
        selectedImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview().priority(.required)
            make.width.height.equalTo(20)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.left.equalTo(selectedImageView.snp.right).offset(15)
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    private func getImageForState(selected: Bool) -> UIImage {
        (selected
         ? UIImage(systemName: "checkmark.circle.fill")!
         : UIImage(systemName: "circle")!
        ).withTintColor(.carrotOrange, renderingMode: .alwaysOriginal)
    }
}
