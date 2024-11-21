//
//  Specification.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

protocol Specification {
    func isSatisfied() -> Bool
}

extension Specification {
    func and(_ other: Specification) -> Specification {
        AndSpecification(self, other)
    }

    func or(_ other: Specification) -> Specification {
        OrSpecification(self, other)
    }

    func not() -> Specification {
        NotSpecification(self)
    }
}

struct AndSpecification: Specification {
    let lhs: Specification
    let rhs: Specification

    init(_ lhs: Specification, _ rhs: Specification) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
    func isSatisfied() -> Bool {
        return lhs.isSatisfied() && rhs.isSatisfied()
    }
}

struct OrSpecification: Specification {
    let lhs: Specification
    let rhs: Specification

    init(_ lhs: Specification, _ rhs: Specification) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
    func isSatisfied() -> Bool {
        return lhs.isSatisfied() || rhs.isSatisfied()
    }
}

struct NotSpecification: Specification {
    let spec: Specification

    init(_ spec: Specification) {
        self.spec = spec
    }
    
    func isSatisfied() -> Bool {
        return !spec.isSatisfied()
    }
}
