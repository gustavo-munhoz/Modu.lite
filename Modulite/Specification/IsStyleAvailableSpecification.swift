//
//  IsStyleAvailableSpecification.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import Foundation

struct IsStyleAvailableSpecification: Specification {
    
    let styleIdentifier: String
    
    func isSatisfied() -> Bool {
        IsPlusSubscriberSpecification()
            .and(IsStyleIncludedInPlusSpecification(styleIdentifier: styleIdentifier))
            .or(HasPurchasedStyleSpecification(styleIdentifier: styleIdentifier))
            .isSatisfied()
    }
}
