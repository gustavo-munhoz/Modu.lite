//
//  SubscriptionYearOptionView.swift
//  Modulite
//
//  Created by André Wozniack on 14/11/24.
//

import UIKit
import SnapKit

class SubscriptionYearOptionView: UIView {
    
    // MARK: - Properties
    
    var isSelected: Bool = false
    
    var onSelectionChanged: ((Bool) -> Void)?
    
    private(set) lazy var periodLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusYearlyTitle)
        view.textColor = .black
        view.font = .spaceGrotesk(textStyle: .title2, weight: .bold)
        return view
    }()
    
    private(set) lazy var fromLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusFrom)
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 9, weight: .light)
        return view
    }()
    
    private(set) lazy var priceWithoutDiscountLabel: UILabel = {
        let view = UILabel()
        view.text = String.localized(for: SettingsLocalizedTexts.offerPlusYearlyPriceWithoutDiscount)
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        view.textAlignment = .center
        addDiagonalStrikeThrough(to: view)
        return view
    }()
    
    private func addDiagonalStrikeThrough(to label: UILabel) {
        let strikeThrough = UIView()
        strikeThrough.backgroundColor = UIColor.ketchupRed
        strikeThrough.layer.cornerRadius = 2
        let thickness: CGFloat = 2.0
        
        label.addSubview(strikeThrough)
        strikeThrough.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(label)
            make.width.equalTo(label.snp.width)
            make.height.equalTo(thickness)
        }
        strikeThrough.transform = CGAffineTransform(rotationAngle: .pi / -20)
    }
    
    private(set) lazy var forLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusFor)
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        return view
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusYearlyPrice)
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return view
    }()
    
    private(set) lazy var aproxLabel: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusAprox)
        view.textColor = .carrotOrange
        view.font = UIFont.systemFont(ofSize: 9.73, weight: .regular)
        return view
    }()
    
    private(set) lazy var monthlyPrice: UILabel = {
        let view = UILabel()
        view.text = .localized(for: SettingsLocalizedTexts.offerPlusYearlyMonthlyPrice)
        view.textColor = .carrotOrange
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    private(set) lazy var monthsOffLabel: GradientLabelView = {
        let gradient = GradientLabelView(gradient: .tropical())
        gradient.text = .localized(for: SettingsLocalizedTexts.offerPlus2MonthsOff)
        gradient.textColor = .white
        gradient.textAlignment = .center
        gradient.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        gradient.clipsToBounds = true
        gradient.layer.cornerRadius = 11
        return gradient
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
        addSubview(fromLabel)
        addSubview(priceWithoutDiscountLabel)
        addSubview(forLabel)
        addSubview(priceLabel)
        addSubview(aproxLabel)
        addSubview(monthlyPrice)
        addSubview(monthsOffLabel)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(146)
            make.height.equalTo(171)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        fromLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(periodLabel.snp.bottom).offset(0.5)
        }
        
        priceWithoutDiscountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fromLabel.snp.bottom).offset(-0.5)
        }
        
        forLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(priceWithoutDiscountLabel.snp.bottom)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(forLabel.snp.bottom)
        }
        
        aproxLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.left.equalTo(monthlyPrice)
        }
        
        monthlyPrice.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(aproxLabel.snp.bottom)
        }
        
        monthsOffLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(monthlyPrice.snp.bottom).offset(4)
            make.width.equalTo(105)
            make.height.equalTo(22)
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
    SubscriptionYearOptionView()
}
