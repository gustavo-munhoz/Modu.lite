//
//  StyleCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit
import SnapKit

class StyleCollectionViewCell: UICollectionViewCell {
    static let reuseId = "StyleCollectionViewCell"
    
    // MARK: - Properties
    var hasSelectionBeenMade: Bool = false {
        didSet {
            updateOverlayAlpha()
        }
    }
    
    override var isSelected: Bool {
        didSet {
         updateOverlayAlpha()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    private(set) lazy var styleImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0
        view.layer.cornerRadius = 14
        
        return view
    }()
    
    private(set) lazy var styleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(textStyle: .body, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Setup methods
    func setup(image: UIImage, title: String) {
        subviews.forEach { $0.removeFromSuperview() }
        
        styleImageView.image = image
        styleTitle.text = title
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(styleImageView)
        styleImageView.addSubview(overlayView)
        addSubview(styleTitle)
    }
    
    private func setupConstraints() {
        styleImageView.snp.makeConstraints { make in
            make.height.equalTo(187)
            make.left.right.top.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        styleTitle.snp.makeConstraints { make in
            make.top.equalTo(styleImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    private func updateOverlayAlpha() {
        if hasSelectionBeenMade {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self = self else { return }
                    self.overlayView.alpha = self.isSelected ? 0 : 0.5
                }
            }
            
            styleImageView.animateBorderColor(
                toColor: isSelected ? UIColor.lemonYellow : .clear,
                duration: 0.25
            )
            
            styleImageView.layer.borderWidth = isSelected ? 4 : 0
            
        } else {
            overlayView.alpha = 0
        }
    }
}
