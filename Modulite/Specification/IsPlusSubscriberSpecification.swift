//
//  IsPlusSubscriberSpecification.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

struct IsPlusSubscriberSpecification: Specification {
    let subscriptionManager = SubscriptionManager.shared

    func isSatisfied() -> Bool {
        subscriptionManager.activeSubscription != nil
    }
}
