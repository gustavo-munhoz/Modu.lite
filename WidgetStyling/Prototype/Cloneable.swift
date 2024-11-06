//
//  Cloneable.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import Foundation

protocol Cloneable: AnyObject {
    init(_ prototype: Self)
}

extension Cloneable {
    func clone() -> Self {
        type(of: self).init(self)
    }
}
