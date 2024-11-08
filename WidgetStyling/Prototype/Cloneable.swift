//
//  Cloneable.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import Foundation

public protocol Cloneable: AnyObject {
    init(_ prototype: Self)
}

extension Cloneable {
    public func clone() -> Self {
        type(of: self).init(self)
    }
}
