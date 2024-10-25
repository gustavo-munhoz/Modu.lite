//
//  View+PulseEffect.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/10/24.
//

import SwiftUI

public extension View {
    func pulseEffect(range: ClosedRange<Double> = 0.5...1, duration: TimeInterval = 0.75) -> some View {
        modifier(PulseEffect(range: range, duration: duration))
    }
}

struct PulseEffect: ViewModifier {
    @State private var pulseIsInMaxState: Bool = true
    private let range: ClosedRange<Double>
    private let duration: TimeInterval

    init(range: ClosedRange<Double>, duration: TimeInterval) {
        self.range = range
        self.duration = duration
    }

    func body(content: Content) -> some View {
        content
            .opacity(pulseIsInMaxState ? range.upperBound : range.lowerBound)
            .onAppear { pulseIsInMaxState = false }
            .animation(
                .easeInOut(duration: duration).repeatForever(),
                value: pulseIsInMaxState
            )
    }
}
