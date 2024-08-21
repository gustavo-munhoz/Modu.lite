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
    private(set) lazy var circleLayer: CAShapeLayer = {
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: frame.size)).cgPath
        
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
        circleLayer.fillColor = color.cgColor
    }
}
