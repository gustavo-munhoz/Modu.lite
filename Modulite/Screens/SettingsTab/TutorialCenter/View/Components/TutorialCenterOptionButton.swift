//
//  TutorialCenterOptionButton.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit
import SnapKit

class TutorialCenterOptionButton: UIButton {
    
    // MARK: - Initializer
    convenience init(
        textLocalizedKey: TutorialCenterLocalizedTexts,
        hasVideoIcon: Bool = false
    ) {
        self.init(frame: .zero)
        configureButton()
        setupViews(textLocalizedKey: textLocalizedKey, hasVideoIcon: hasVideoIcon)
        addSeparator()
    }
    
    // MARK: - Setup Methods
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        self.configuration = config
        
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                if button.isHighlighted {
                    button.backgroundColor = .lightGray.withAlphaComponent(0.15)
                    return
                }
                
                button.backgroundColor = .clear
            }
        }
    }
    
    private func setupViews(
        textLocalizedKey: TutorialCenterLocalizedTexts,
        hasVideoIcon: Bool
    ) {
        let title = TutorialCenterButtonLabel(textLocalizedKey: textLocalizedKey)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        addSubview(title)
        
        if hasVideoIcon {
            let videoIcon = UIImage(systemName: "play.square")!
                .withTintColor(.carrotOrange, renderingMode: .alwaysOriginal)
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24))
            
            let videoImageView = UIImageView(image: videoIcon)
            videoImageView.setContentCompressionResistancePriority(
                .required,
                for: .horizontal
            )
            
            addSubview(videoImageView)
            
            videoImageView.snp.makeConstraints { make in
                make.centerY.left.equalToSuperview()
                make.width.height.equalTo(24)
            }
            
            title.snp.makeConstraints { make in
                make.centerY.right.equalToSuperview()
                make.left.equalTo(videoImageView.snp.right).offset(8)
            }
            
            return
        }
        
        let chevronImage = UIImage(systemName: "chevron.right")?
            .withTintColor(.figBlue, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold))
        
        let chevronImageView = UIImageView(image: chevronImage)
        chevronImageView.contentMode = .scaleAspectFit
        addSubview(chevronImageView)
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.right.equalToSuperview().inset(8)
        }
        
        title.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
            make.right.equalTo(chevronImageView.snp.left).offset(-8)
        }
    }
    
    private func addSeparator() {
        let separator = SeparatorView()
        addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }
}
