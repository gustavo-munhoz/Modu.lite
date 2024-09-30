//
//  Copying.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/09/24.
//

import Foundation

protocol Copying: AnyObject {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        type(of: self).init(self)
    }
}
