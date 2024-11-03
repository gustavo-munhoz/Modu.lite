//
//  Gradient.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/10/24.
//

import UIKit

struct Gradient {
    let colors: [CGColor]
    let startPoint: CGPoint
    let endPoint: CGPoint
    
    init(colors: [UIColor], direction: CGVector) {
        self.colors = colors.map { $0.cgColor }
        self.startPoint = CGPoint(x: 0.5 - direction.dx / 2, y: 0.5 - direction.dy / 2)
        self.endPoint = CGPoint(x: 0.5 + direction.dx / 2, y: 0.5 + direction.dy / 2)
    }
        
    static func tropical(direction: CGVector = CGVector(dx: 1, dy: 0)) -> Gradient {
        Gradient(
            colors: [
                UIColor(red: 0.777, green: 0.271, blue: 0.220, alpha: 1),
                UIColor(red: 0.808, green: 0.459, blue: 0.23, alpha: 1)
            ],
            direction: direction
        )
    }
    
    static func potato(direction: CGVector = CGVector(dx: 0, dy: 1)) -> Gradient {
        Gradient(
            colors: [
                .potatoYellow.resolvedColor(
                    with: UITraitCollection(userInterfaceStyle: .light)
                ),
                .lemonYellow
            ],
            direction: direction
        )
    }
    
    static func ambrosia(direction: CGVector = CGVector(dx: 1, dy: 0)) -> Gradient {
        Gradient(
            colors: [
                UIColor(red: 0.886, green: 0.682, blue: 0.282, alpha: 1),
                UIColor(red: 0.808, green: 0.459, blue: 0.23, alpha: 1)
            ],
            direction: direction
        )
    }
}
