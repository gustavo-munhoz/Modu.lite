//
//  HasPurchasedStyleSpecification.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

struct HasPurchasedStyleSpecification: Specification {
    let purchaseManager = PurchaseManager.shared
    let styleIdentifier: String

    func isSatisfied() -> Bool {
        purchaseManager.isSkinPurchased(styleIdentifier)
    }
}
