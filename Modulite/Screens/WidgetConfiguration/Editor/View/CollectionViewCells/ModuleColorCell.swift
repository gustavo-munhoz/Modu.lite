//
//  ModuleColorCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/08/24.
//

import UIKit

class ModuleColorCell: UICollectionViewCell {
    static let reuseId = "ModuleColorCell"
    
    // MARK: - Properties
    
    private var isColorSelected: Bool = false
    
    var color: UIColor?
    
    private(set) lazy var circleLayer: CAShapeLayer = {
        let circle = CAShapeLayer()
        
        let insetBounds = bounds.insetBy(dx: 2, dy: 2)
        
        circle.path = UIBezierPath(ovalIn: insetBounds).cgPath
        circle.lineWidth = 2
        
        return circle
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    func addLayers() {
        layer.addSublayer(circleLayer)
    }
    
    func setup(with color: UIColor) {
        self.color = color
        circleLayer.fillColor = color.cgColor
    }
    
    // MARK: - Actions
    
    func setSelected(to isSelected: Bool) {
        isColorSelected = isSelected
        updateBorderAndShadow()
    }
    
    private func updateBorderAndShadow() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            
            if self.isColorSelected {
                self.circleLayer.strokeColor = UIColor.systemGray.cgColor
                self.circleLayer.shadowColor = UIColor.black.cgColor
                self.circleLayer.shadowOffset = CGSize(width: 4, height: 5)
                self.circleLayer.shadowOpacity = 0.4
                self.circleLayer.shadowRadius = 3
                self.circleLayer.masksToBounds = false
                
                return
            }
            
            self.circleLayer.shadowOpacity = 0
            self.circleLayer.strokeColor = UIColor.clear.cgColor
        }
        
    }
}
