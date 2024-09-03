//
//  UIView+asImage.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/09/24.
//

import UIKit

extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
