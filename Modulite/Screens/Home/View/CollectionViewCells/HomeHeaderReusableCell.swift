//
//  HomeHeaderReusableCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import SnapKit

class HomeHeaderReusableCell: UICollectionViewCell {
    static let reuseId = "HomeHeaderReusableCell"
    
    // MARK: - Properties
    
    var onButtonTap: (() -> Void)?
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
                
        view.font = UIFont(textStyle: .title2, weight: .bold)
        view.textColor = .textPrimary
        
        return view
    }()
    
    private(set) lazy var actionButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2)
        let customFd = fd.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold
        ]])
        
        config.preferredSymbolConfigurationForImage = .init(font: UIFont(descriptor: customFd, size: 0))
        
        config.contentInsets = .zero
        
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        
        view.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.alpha = 0.6
            default:
                button.alpha = 1
            }
        }
        
        return view
    }()
    
    private(set) var countLabel: UILabel = {
        let view = UILabel()
        
        view.font = UIFont(textStyle: .body, weight: .regular)
        view.textColor = .secondaryLabel
        
        return view
    }()
    
    private(set) lazy var plusBadge = ModulitePlusSmallBadge()
    
    private var didAddSubviews = false
    
    // MARK: - Setup methods
    
    func setup(
        title: String,
        buttonImage: UIImage? = nil,
        buttonColor: UIColor = .fiestaGreen,
        buttonAction: @escaping () -> Void = {},
        isPlusExclusive: Bool = false,
        countValues: (current: Int, max: Int)? = nil
    ) {
        actionButton.configuration?.image = buttonImage
        actionButton.configuration?.baseForegroundColor = buttonColor
        onButtonTap = buttonAction
        titleLabel.text = title
        
        var shouldAddCount: Bool
        if let (count, max) = countValues {
            shouldAddCount = true
            countLabel.text = "\(count)/\(max)"
            
        } else {
            shouldAddCount = false
        }
        
        if didAddSubviews { return }
        
        addSubviews(shouldAddBadge: isPlusExclusive, shouldAddCount: shouldAddCount)
        setupContraints(shouldAddBadge: isPlusExclusive, shouldAddCount: shouldAddCount)
        didAddSubviews = true
    }
    
    private func addSubviews(
        shouldAddBadge: Bool,
        shouldAddCount: Bool
    ) {
        addSubview(titleLabel)
        
        if shouldAddBadge { addSubview(plusBadge) }
        
        addSubview(actionButton)
        
        if shouldAddCount { addSubview(countLabel) }
    }
    
    private func setupContraints(
        shouldAddBadge: Bool,
        shouldAddCount: Bool
    ) {
        titleLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }
        
        if shouldAddBadge {
            plusBadge.snp.makeConstraints { make in
                make.width.equalTo(70)
                make.height.equalTo(31)
                make.centerY.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right).offset(12)
            }
        }
        
        if shouldAddCount {
            countLabel.snp.makeConstraints { make in
                make.centerY.equalTo(actionButton)
                make.right.equalTo(actionButton.snp.left).offset(-8)
            }
        }
    }
    
    // MARK: - Actions
    
    func updateCurrentCount(to newCount: Int) {
        guard let text = countLabel.text else { return }
        
        var separated = text.components(separatedBy: "/")
        separated[0] = String(newCount)
        
        countLabel.text = separated.joined(separator: "/")
    }
    
    @objc func handleButtonTap() {
        onButtonTap?()
    }
}
