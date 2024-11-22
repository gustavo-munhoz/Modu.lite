//
//  SubscriptionOptionView.swift
//  Modulite
//
//  Created by André Wozniack on 13/11/24.
//

import UIKit
import SnapKit

class SubscriptionMonthOptionView: UIView {
    // MARK: - Properties
    
    var isSelected: Bool = false

    var onSelectionChanged: ((Bool) -> Void)?
    
    private(set) lazy var periodLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusMonthlyTitle)
        view.textColor = .black
        view.font = .spaceGrotesk(textStyle: .title2, weight: .bold)
        return view
    }()
    
    private(set) lazy var forOnlyLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusForOnly)
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 9.73, weight: .light)
        return view
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusMonthlyPrice)
        view.textColor = .carrotOrange
        view.font = UIFont(textStyle: .title1, weight: .semibold)
        return view
    }()
    
    private(set) lazy var cancelLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusCancelAnytime)
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 9.73, weight: .ultraLight)
        return view
    }()
    
    private lazy var checkmarkView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 35 / 2
        container.layer.masksToBounds = true
        container.isHidden = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.setup(
            with: Gradient.ambrosia(
                direction: CGVector(dx: -1, dy: 0)
            )
        )
        gradientLayer.cornerRadius = 35 / 2
        container.layer.insertSublayer(gradientLayer, at: 0)
        
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(
            systemName: "checkmark"
        )?.withTintColor(
            .white,
            renderingMode: .alwaysOriginal
        )
        container.addSubview(checkmarkImageView)

        checkmarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        container.layoutIfNeeded()
        gradientLayer.frame = container.bounds

        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: -1, height: 2)
        container.layer.shadowRadius = 4
        
        return container
    }()
    
    private lazy var gradientBorderLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.setup(with: .tropical())
        gradientLayer.isHidden = true
        return gradientLayer
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 6
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        return shapeLayer
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = false
        
        gradientBorderLayer.mask = shapeLayer
        layer.addSublayer(gradientBorderLayer)
        
        addSubviews()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    override func layoutSubviews() {
        super.layoutSubviews()
        checkmarkView.layer.sublayers?.first?.frame = checkmarkView.bounds
        
        gradientBorderLayer.frame = bounds
        let inset = shapeLayer.lineWidth / 2.8
        let path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: inset, dy: inset),
            cornerRadius: layer.cornerRadius
        )
        shapeLayer.path = path.cgPath
        shapeLayer.frame = bounds
    }
    
    private func addSubviews() {
        addSubview(checkmarkView)
        addSubview(periodLabel)
        addSubview(forOnlyLabel)
        addSubview(priceLabel)
        addSubview(cancelLabel)
    }
    
    private func setupConstraints() {
        snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(146)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(22)
        }
        
        forOnlyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(periodLabel.snp.bottom).offset(4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(forOnlyLabel.snp.bottom).offset(8)
        }
        
        cancelLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
        }
        
        checkmarkView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(10)
            make.width.height.equalTo(35)
        }
    }
    
    // MARK: - Selection Logic
    
    func updateSelectionState() {
        if isSelected {
            gradientBorderLayer.isHidden = false
            bringSubviewToFront(checkmarkView)
            checkmarkView.isHidden = false
        } else {
            gradientBorderLayer.isHidden = true
            checkmarkView.isHidden = true
        }
    }

    @objc private func handleTap() {
        isSelected.toggle()
        updateSelectionState()
        onSelectionChanged?(isSelected)
    }
}

#Preview {
    SubscriptionMonthOptionView()
}
