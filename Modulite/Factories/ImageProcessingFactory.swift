//
//  ImageProcessingFactory.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 22/08/24.
//

import UIKit

class ImageProcessingFactory {
    
    static func createColorBlendedImage(
        _ image: UIImage,
        mode: CGBlendMode,
        color: UIColor
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        color.setFill()
        let rect = CGRect(origin: .zero, size: image.size)
        UIRectFillUsingBlendMode(rect, mode)
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return blendedImage
    }
}
