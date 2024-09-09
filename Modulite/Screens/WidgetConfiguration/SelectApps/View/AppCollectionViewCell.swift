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
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectedImageView.setSymbolImage(
                getImageForState(selected: isSelected),
                contentTransition: .replace
            )
        }
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            self.appNameLabel.alpha = isUserInteractionEnabled ? 1 : 0.5
            self.selectedImageView.alpha = isUserInteractionEnabled ? 1 : 0.5
        }
    }
    
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
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubviews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedImageView.image = nil
    }
    
    func setup(with app: SelectableAppInfo) {
        appNameLabel.text = app.data.name
        
        if selectedImageView.image == getImageForState(selected: app.isSelected) {
            return
        }
        
        selectedImageView.setSymbolImage(
            getImageForState(selected: app.isSelected),
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
    
    // MARK: - Helper methods
    
    private func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            guard let self = self else { return }
            
            self.backgroundColor = self.isHighlighted ? .systemGray.withAlphaComponent(0.1) : .clear
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
            CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
            CGAffineTransform.identity
            
        })
    }
    
    private func getImageForState(selected: Bool) -> UIImage {
        (selected
         ? UIImage(systemName: "checkmark.circle.fill")!
         : UIImage(systemName: "circle")!
        ).withTintColor(.carrotOrange, renderingMode: .alwaysOriginal)
    }
}
