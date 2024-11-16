//
//  WidgetStylingProvider+PurchasedSkins.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/11/24.
//

import WidgetStyling

extension WidgetStyleProvider {
    convenience init(purchasedSkins: Set<String>) throws {
        try self.init()
        setPurchasedStyles(purchasedSkins)
    }
}
