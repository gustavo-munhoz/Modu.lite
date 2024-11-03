//
//  WelcomeView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/10/24.
//

import UIKit
import SnapKit

class WelcomeView: UIView {
    
    var onStartButtonPressed: (() -> Void)?
    
    // MARK: - Subviews
    private(set) lazy var welcomeTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        label.attributedText = NSAttributedString(
            string: .localized(for: OnboardingLocalizedTexts.onboardingWelcomeTitle),
            attributes: [
                .font: UIFont.spaceGrotesk(textStyle: .largeTitle, weight: .bold),
                .foregroundColor: UIColor.fiestaGreen,
                .kern: -0.4
            ]
        )
        
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: OnboardingLocalizedTexts.onboardingWelcomeSubtitle)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont(textStyle: .callout, weight: .semibold)
        
        return label
    }()
    
    private(set) lazy var mockupImage: UIImageView = {
        let view = UIImageView(image: .onboardingWelcomeMockup)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) lazy var startButton: UIButton = {
        let view = ButtonFactory.mediumButton(
            titleKey: OnboardingLocalizedTexts.onboardingGetStartedButton,
            image: UIImage(systemName: "arrow.right"),
            imagePlacement: .trailing
        )
        
        view.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteTurnip
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func addSubviews() {
        addSubview(welcomeTitle)
        addSubview(subtitleLabel)
        addSubview(mockupImage)
        addSubview(startButton)
    }
    
    private func setupConstraints() {
        welcomeTitle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeTitle.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(28)
        }
        
        mockupImage.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(mockupImage.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(230)
            make.height.greaterThanOrEqualTo(45)
        }
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        onStartButtonPressed?()
    }
}

#Preview {
    WelcomeView()
}
