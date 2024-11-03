//
//  StyleCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit
import SnapKit

protocol StyleCollectionViewCellDelegate: AnyObject {
    func styleCollectionViewCellDidPressPreview(_ cell: StyleCollectionViewCell)
}

class StyleCollectionViewCell: UICollectionViewCell {
    static let reuseId = "StyleCollectionViewCell"
    
    // MARK: - Properties
    
    weak var delegate: StyleCollectionViewCellDelegate?
    
    var isPurchased: Bool = false
    
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
    
    private(set) lazy var previewButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye")
        config.imagePadding = 0
        config.baseForegroundColor = .white
        config.background.backgroundColor = UIColor.blueberry

        let view = UIButton(configuration: config)
        
        view.layer.cornerRadius = 34/2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.whiteTurnip.resolvedColor(
            with: .init(userInterfaceStyle: .light)
        ).cgColor
        
        view.clipsToBounds = true
        
        view.snp.makeConstraints { make in
            make.width.height.equalTo(34)
        }
        
        view.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var unlockBadge: UILabel = {
        // TODO: Change text to localizable format
        let label = UILabel()
        label.text = "Unlock for $0.99"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.backgroundColor = UIColor.carrotOrange
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    // MARK: - Setup methods
    func setup(image: UIImage, title: String, delegate: StyleCollectionViewCellDelegate, isPurchased: Bool) {
        subviews.forEach { $0.removeFromSuperview() }
        self.delegate = delegate
        styleImageView.image = image
        styleTitle.text = title
        
        addSubviews()
        setupConstraints()
        unlockBadge.isHidden = isPurchased
    }
    
    private func addSubviews() {
        addSubview(styleImageView)
        styleImageView.addSubview(overlayView)
        addSubview(styleTitle)
        addSubview(previewButton)
        addSubview(unlockBadge)
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
        
        previewButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-16)
        }
        
        unlockBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.equalTo(80) // ou ajuste conforme necessário
            make.height.equalTo(24)
        }
    }
    
    // MARK: - Actions
    @objc private func previewButtonTapped() {
        delegate?.styleCollectionViewCellDidPressPreview(self)
    }
    
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
