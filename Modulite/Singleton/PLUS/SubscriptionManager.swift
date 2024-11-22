//
//  SubscriptionManager.swift
//  Modulite
//
//  Created by André Wozniack on 06/11/24.
//

import StoreKit

final class SubscriptionManager {
    static let shared = SubscriptionManager()
    
    @Published private(set) var activeSubscription: String?
    @Published private(set) var products: [Product] = []
    
    // MARK: - Initialization
    
    private init() { }
    
    @MainActor func initialize() async {
        await fetchActiveSubscriptions()
        await fetchProducts()
        startObservingTransactionUpdates()
    }
    
    // MARK: - Fetch Products
    
    private func fetchProducts() async {
        do {
            let productIDs = ["modulite.plus.monthly", "modulite.plus.yearly"]
            let fetchedProducts = try await Product.products(for: productIDs)
            await MainActor.run {
                self.products = fetchedProducts
            }
        } catch {
            print("Failed to fetch subscription products: \(error.localizedDescription)")
            await MainActor.run {
                self.products = []
            }
        }
    }
    
    // MARK: - Fetch Active Subscription
    
    private func fetchActiveSubscriptions() async {
        var foundActiveSubscription = false
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction) where transaction.productType == .autoRenewable:
                await MainActor.run {
                    self.activeSubscription = transaction.productID
                }
                foundActiveSubscription = true
                
            case .unverified:
                print("Unverified subscription entitlement")
            default:
                break
            }
            if foundActiveSubscription {
                break
            }
        }
        
        if !foundActiveSubscription {
            await MainActor.run {
                self.activeSubscription = nil
            }
        }
    }
    
    // MARK: - Purchase Subscription

    func purchase(
        subscription: Product,
        completion: @escaping (Result<Void, SubscriptionError>) -> Void
    ) {
        Task {
            do {
                let result = try await subscription.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction) where transaction.productType == .autoRenewable:
                        await handleSubscription(transaction)
                        completion(.success(()))
                    case .unverified:
                        completion(.failure(.failedVerification))
                    default:
                        completion(.success(()))
                    }
                case .userCancelled:
                    completion(.failure(.userCancelled))
                case .pending:
                    completion(.failure(.pending))
                @unknown default:
                    completion(.failure(.unknown))
                }
            } catch {
                completion(.failure(.unknown))
            }
        }
    }

    // MARK: - Restore Purchases

    func restorePurchases() async throws {
        try await AppStore.sync()
        await fetchActiveSubscriptions()
    }
    
    // MARK: - Transaction Updates

    private func startObservingTransactionUpdates() {
        Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction) where transaction.productType == .autoRenewable:
                    await handleSubscription(transaction)
                case .unverified:
                    print("Transaction verification failed")
                default:
                    break
                }
            }
        }
    }

    private func handleSubscription(_ transaction: Transaction) async {
        await MainActor.run {
            self.activeSubscription = transaction.productID
        }
        await transaction.finish()
    }
    
    // MARK: - Helper Methods

    func isSubscribed(to productID: String) -> Bool {
        return activeSubscription == productID
    }
    
    func isAnySubscriptionActive() -> Bool {
        return activeSubscription != nil
    }
    
    func getProduct(withID id: String) -> Product? {
        return products.first { $0.id == id }
    }

    // MARK: - Manage Subscriptions

    func manageSubscriptions(in windowScene: UIWindowScene?) {
        Task { @MainActor in
            do {
                guard let windowScene = windowScene else {
                    print("Failed to obtain UIWindowScene.")
                    return
                }
                
                try await AppStore.showManageSubscriptions(in: windowScene)
                
            } catch {
                print("Failed to open manage subscriptions: \(error)")
            }
        }
    }
}

// MARK: - SubscriptionError Enum

enum SubscriptionError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
}
