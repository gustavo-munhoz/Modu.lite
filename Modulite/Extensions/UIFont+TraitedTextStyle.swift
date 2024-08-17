//
//  UIFont+TraitedTextStyle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit

extension UIFont {
    convenience init(
        textStyle: UIFont.TextStyle,
        weight: UIFont.Weight
    ) {
        self.init(
            descriptor:
                .preferredFontDescriptor(withTextStyle: textStyle)
                .addingAttributes([.traits: [
                    UIFontDescriptor.TraitKey.weight: weight
                ]]),
            size: 0
        )
    }
    
    convenience init?(
        textStyle: UIFont.TextStyle,
        symbolicTraits: UIFontDescriptor.SymbolicTraits
    ) {
        let baseDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        guard let descriptor = baseDescriptor.withSymbolicTraits(symbolicTraits) else {
            return nil
        }
        
        self.init(descriptor: descriptor, size: 0)
    }
}
