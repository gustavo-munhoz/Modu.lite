//
//  RedirectingView.swift
//  Modulite
//
//  Created by André Wozniack on 29/10/24.
//

import UIKit
import SnapKit

class RedirectingView: UIView {
    
    private(set) lazy var redirectingText: UILabel = {
        let view = UILabel()
        view.text = "Redirecting..."
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = UIColor.textPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let circleSize: CGFloat = 20.0
    private let circleSpacing: CGFloat = 15.0
    private var circleLayers: [CAShapeLayer] = []
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(redirectingText)
        setupConstraints()
        backgroundColor = UIColor.whiteTurnip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if circleLayers.isEmpty {
            addCircles()
            startAnimation()
        }
    }

    private func setupConstraints() {
        redirectingText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(60)
        }
    }
    
    private func addCircles() {
        let colors: [UIColor] = [.fiestaGreen, .ketchupRed, .eggYolk]
        let totalWidth = (circleSize * 3) + (circleSpacing * 2)
        let startX = (bounds.width - totalWidth) / 2
        let yPosition = bounds.midY
        
        for i in 0..<3 {
            let xPosition = startX + CGFloat(i) * (circleSize + circleSpacing)
            let circleLayer = CAShapeLayer()
            let circlePath = UIBezierPath(
                ovalIn: CGRect(
                    x: 0,
                    y: 0,
                    width: circleSize,
                    height: circleSize
                )
            )
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = colors[i].cgColor
            
            circleLayer.frame = CGRect(
                x: xPosition,
                y: yPosition,
                width: circleSize,
                height: circleSize
            )
            
            layer.addSublayer(circleLayer)
            circleLayers.append(circleLayer)
        }
    }
    
    private func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        for (index, circleLayer) in circleLayers.enumerated() {
            animateCircle(circleLayer: circleLayer, delay: Double(index) * 0.2)
        }
    }
    
    private func animateCircle(circleLayer: CAShapeLayer, delay: TimeInterval) {
        let animationDuration: TimeInterval = 0.7
        let jumpHeight: CGFloat = 35.0

        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = -jumpHeight
        animation.duration = animationDuration / 2
        animation.beginTime = CACurrentMediaTime() + delay
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        circleLayer.add(animation, forKey: "jump")
    }
}
