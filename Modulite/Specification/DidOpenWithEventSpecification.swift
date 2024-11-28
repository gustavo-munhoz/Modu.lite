//
//  DidOpenWithEventSpecification.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 28/11/24.
//

import Foundation

struct DidOpenWithEventSpecification: Specification {
    func isSatisfied() -> Bool {
        UserDefaults.standard.bool(forKey: "shouldPresentOfferPlus")
    }
}
