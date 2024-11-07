//
//  SubscriptionManager.swift
//  Modulite
//
//  Created by André Wozniack on 06/11/24.
//

import StoreKit

class SubscriptionManager: NSObject, ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var activeSubscription: String?
    
    private override init() {
        super.init()
        Task {
            await fetchActiveSubscriptions()
            startObservingTransactionUpdates()
        }
    }
    
    // MARK: - Produtos e Assinaturas
    func fetchProducts() async throws -> [Product] {
        let productIDs: [String] = ["modulite.plus.monthly", "modulite.plus.yearly"]
        let products = try await Product.products(for: productIDs)
        return products
    }

    func fetchActiveSubscriptions() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productType == .autoRenewable {
                    await handleSubscription(transaction: transaction)
                }
            case .unverified:
                print("Assinatura não verificada")
            }
        }
    }
    
    func purchase(subscription: Product) async throws {
        let result = try await subscription.purchase()
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                if transaction.productType == .autoRenewable {
                    await handleSubscription(transaction: transaction)
                }
            case .unverified:
                throw SubscriptionError.failedVerification
            }
        case .userCancelled:
            throw SubscriptionError.userCancelled
        case .pending:
            throw SubscriptionError.pending
        @unknown default:
            throw SubscriptionError.unknown
        }
    }

    func restorePurchases() async throws {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productType == .autoRenewable {
                    await handleSubscription(transaction: transaction)
                }
            case .unverified:
                throw SubscriptionError.failedVerification
            }
        }
    }
    
    // MARK: - Observação de Atualizações de Transação

    private func startObservingTransactionUpdates() {
        Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    if transaction.productType == .autoRenewable {
                        await handleSubscription(transaction: transaction)
                    }
                case .unverified:
                    print("Erro de verificação de transação")
                }
            }
        }
    }
    
    private func handleSubscription(transaction: Transaction) async {
        // Registra a assinatura ativa
        activeSubscription = transaction.productID
        saveActiveSubscription(transaction.productID)
        
        // Finaliza a transação
        await transaction.finish()
    }
    
    // MARK: - Persistência de Assinatura

    private func saveActiveSubscription(_ productID: String) {
        UserDefaults.standard.set(productID, forKey: "activeSubscription")
    }

    private func loadActiveSubscription() {
        if let savedSubscription = UserDefaults.standard.string(forKey: "activeSubscription") {
            activeSubscription = savedSubscription
        }
    }
    
    func isSubscribed(to productID: String) -> Bool {
        activeSubscription == productID
    }
}

enum SubscriptionError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
}
