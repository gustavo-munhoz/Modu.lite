//
//  AsyncSequence+Collect.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 15/10/24.
//

import Foundation

extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}
