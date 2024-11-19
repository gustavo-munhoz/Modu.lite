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
    
    private init() {}
    
    @MainActor func initialize() {
        Task {
            await fetchActiveSubscriptions()
            await fetchProducts()
            startObservingTransactionUpdates()
        }
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
    
    // MARK: - Fetch Active Subscriptions
    
    private func fetchActiveSubscriptions() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction) where transaction.productType == .autoRenewable:
                await handleSubscription(transaction)
            case .unverified:
                print("Unverified subscription entitlement")
            default:
                break
            }
        }
    }
    
    // MARK: - Purchase Subscription
    
    // SubscriptionManager.swift

    func purchase(subscription: Product, completion: @escaping (Result<Void, SubscriptionError>) -> Void) {
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
                    case .verified:
                        print("Verified subscription entitlement")
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
                case .verified(_):
                    print("Verified subscription entitlement")
                }
            }
        }
    }
    
    private func handleSubscription(_ transaction: Transaction) async {
        activeSubscription = transaction.productID
        saveActiveSubscription(transaction.productID)
        print("Subscription purchased: \(transaction.productID)")
        await transaction.finish()
    }
    
    // MARK: - Subscription Persistence
    
    private func saveActiveSubscription(_ productID: String) {
        UserDefaults.standard.set(productID, forKey: "activeSubscription")
    }
    
    private func loadActiveSubscription() {
        if let savedSubscription = UserDefaults.standard.string(forKey: "activeSubscription") {
            activeSubscription = savedSubscription
        }
    }
    
    // MARK: - Helper Methods
    
    func isSubscribed(to productID: String) -> Bool {
        activeSubscription == productID
    }
    
    func getProduct(withID id: String) -> Product? {
        return products.first { $0.id == id }
    }
}

// MARK: - SubscriptionError Enum

enum SubscriptionError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
}
