//
//  PurchaseManager.swift
//  Modulite
//
//  Created by André Wozniack on 04/11/24.
//

import Foundation
import StoreKit
import WidgetStyling

final class PurchaseManager {
    static let shared = PurchaseManager()
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedSkins: Set<String> = []
    @Published private(set) var freeSkins: Set<String> = []
    
    // MARK: - Initialization
    
    private init() { }
    
    @MainActor func initialize() async {
        await updatePurchasedProducts()
        await fetchProducts()
        startObservingTransactionUpdates()
    }
    
    // MARK: - Fetch Products
    
    private func fetchProducts() async {
        do {
            let provider = try WidgetStyleProvider(purchasedSkins: purchasedSkins)
            let productIDs = provider.getAllStyles().map { $0.identifier }
            let storeProducts = try await Product.products(for: productIDs)
            await MainActor.run {
                self.freeSkins = Set(provider.getFreeStyles().map(\.identifier))
                self.products = storeProducts
            }
        } catch {
            print("Failed to fetch products: \(error.localizedDescription)")
            await MainActor.run {
                self.products = []
            }
        }
    }
    
    // MARK: - Update Purchased Products
    
    private func updatePurchasedProducts() async {
        let purchasedIDs = await Transaction.currentEntitlements.reduce(
            into: Set<String>()
        ) { result, transactionResult in
            switch transactionResult {
            case .verified(let transaction):
                result.insert(transaction.productID)
            case .unverified(let transaction, _):
                print("Unverified transaction for product ID: \(transaction.productID)")
            }
        }
        await MainActor.run {
            self.purchasedSkins = purchasedIDs
        }
    }
    
    // MARK: - Purchase Product
    
    func purchase(product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await handleTransaction(transaction)
            case .unverified(let transaction, let verificationError):
                print("Unverified transaction: \(transaction), error: \(verificationError.localizedDescription)")
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
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async throws {
        try await AppStore.sync()
        await updatePurchasedProducts()
    }
    
    // MARK: - Transaction Handling
    
    private func startObservingTransactionUpdates() {
        Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    await self.handleTransaction(transaction)
                case .unverified(_, let verificationError):
                    print("Transaction verification failed: \(verificationError.localizedDescription)"
                    )
                }
            }
        }
    }
    
    private func handleTransaction(_ transaction: Transaction) async {
        _ = await MainActor.run {
            self.purchasedSkins.insert(transaction.productID)
        }
        await transaction.finish()
    }
    
    // MARK: - Helper Methods
    
    func isSkinPurchased(_ skinID: String) -> Bool {
        purchasedSkins.contains(skinID) || freeSkins.contains(skinID)
    }
    
    func getProduct(withID id: String) -> Product? {
        return products.first(where: { $0.id == id })
    }
}

// MARK: - PurchaseError Enum

enum PurchaseError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
}
