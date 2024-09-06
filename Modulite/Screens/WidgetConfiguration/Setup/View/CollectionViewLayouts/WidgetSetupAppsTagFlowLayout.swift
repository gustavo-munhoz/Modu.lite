//
//  WidgetSetupAppsTagFlowLayout.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 04/09/24.
//

import UIKit

class WidgetSetupAppsTagFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(
            in: rect
            // swiftlint:disable:next force_cast
        )?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
