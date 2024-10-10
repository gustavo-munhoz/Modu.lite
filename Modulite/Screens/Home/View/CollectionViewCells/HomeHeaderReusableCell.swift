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
    
    private(set) lazy var plusBadge = ModulitePlusSmallBadge()
    
    // MARK: - Setup methods
    
    func setup(
        title: String,
        buttonImage: UIImage? = nil,
        buttonColor: UIColor = .fiestaGreen,
        buttonAction: @escaping () -> Void = {},
        isPlusExclusive: Bool = false
    ) {
        actionButton.configuration?.image = buttonImage
        actionButton.configuration?.baseForegroundColor = buttonColor
        onButtonTap = buttonAction
        
        addSubviews(isPlusExclusive)
        setupContraints(isPlusExclusive)
        
        titleLabel.text = title
    }
    
    private func addSubviews(_ shouldAddBadge: Bool) {
        addSubview(titleLabel)
        
        if shouldAddBadge { addSubview(plusBadge) }
        
        addSubview(actionButton)
    }
    
    private func setupContraints(_ shouldAddBadge: Bool) {
        titleLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }
        
        guard shouldAddBadge else { return }
        
        plusBadge.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(31)
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(12)
        }
    }
    
    // MARK: - Actions
    
    @objc func handleButtonTap() {
        onButtonTap?()
    }
}
