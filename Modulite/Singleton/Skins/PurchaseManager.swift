//
//  PurchaseManager.swift
//  Modulite
//
//  Created by André Wozniack on 04/11/24.
//

import StoreKit
import WidgetStyling

final class PurchaseManager: NSObject, ObservableObject {
    static let shared = PurchaseManager()
    
    @Published var purchasedSkins: Set<String> = []
    
    private(set) var products: [Product] = []
    
    private override init() {
        super.init()
        fetchPurchasedProducts()
        startObservingTransactionUpdates()
        
        Task { self.products = await fetchProducts() }
    }
    
    // MARK: - Produto e Compras

    func fetchProducts() async -> [Product] {
        do {
            let provider = try WidgetStyleProvider()
            let productIDs = provider.getAllStyles().map { $0.identifier }
            return try await Product.products(for: productIDs)
        } catch {
            return []
        }
    }

    func fetchPurchasedProducts() async throws {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                await handlePurchased(transaction: transaction)
            case .unverified:
                break
            }
        }
    }
    
    func getProduct(id: String) -> Product? {
        return products.first(where: { $0.id == id })
    }

    func purchase(product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await handlePurchased(transaction: transaction)
            case .unverified:
                throw PurchaseError.failedVerification
            }
        case .userCancelled:
            throw PurchaseError.userCancelled

        case .pending:
            throw PurchaseError.pending

        @unknown default:
            throw PurchaseError.unknown
        }
    }

    func restorePurchases() async throws {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                await handlePurchased(transaction: transaction)
            case .unverified:
                throw PurchaseError.failedVerification
            }
        }
    }
    
    // MARK: - Atualizações de Transação

    private func startObservingTransactionUpdates() {
        Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    await handlePurchased(transaction: transaction)
                case .unverified:
                    print("Erro de verificação de transação")
                }
            }
        }
    }
    
    private func handlePurchased(transaction: Transaction) async {
        purchasedSkins.insert(transaction.productID)
        savePurchasedSkins()
        await transaction.finish()
    }
    
    // MARK: - Persistência

    private func savePurchasedSkins() {
        let defaults = UserDefaults.standard
        defaults.set(Array(purchasedSkins), forKey: "purchasedSkins")
    }

    private func fetchPurchasedProducts() {
        let defaults = UserDefaults.standard
        if let savedSkins = defaults.array(forKey: "purchasedSkins") as? [String] {
            purchasedSkins = Set(savedSkins)
        }
    }
    
    func isSkinPurchased(for skin: String) -> Bool {
        purchasedSkins.contains(skin)
    }
}

enum PurchaseError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
}
