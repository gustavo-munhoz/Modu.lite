//
//  PurchasedSkinsManager 2.swift
//  Modulite
//
//  Created by André Wozniack on 03/11/24.
//

import Foundation
import StoreKit

class PurchasedSkinsManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let shared = PurchasedSkinsManager()
    private var availableSkins: [SKProduct] = []
    private var productRequest: SKProductsRequest?
    
    var onPurchaseCompleted: ((String) -> Void)?
    var onPurchaseFailed: ((String, Error?) -> Void)?
    var onPurchaseRestored: ((String) -> Void)?
    
    private let purchasedKey = "purchasedWidgetStyles"
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: - Fetch Available Skins
    func fetchAvailableSkins(productIds: [String]) {
        productRequest?.cancel()
        productRequest = SKProductsRequest(productIdentifiers: Set(productIds))
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        availableSkins = response.products
        NotificationCenter.default.post(name: .skinsLoaded, object: nil)
    }
    
    func purchaseSkin(with productId: String) {
        guard SKPaymentQueue.canMakePayments() else {
            print("In-app purchases are disabled.")
            return
        }
        
        guard let product = availableSkins.first(where: { $0.productIdentifier == productId }) else {
            print("Produto de teste não encontrado.")
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - Transaction Handling
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            case .failed:
                failed(transaction: transaction)
            default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        unlockSkin(productId: transaction.payment.productIdentifier)
        onPurchaseCompleted?(transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        unlockSkin(productId: transaction.payment.productIdentifier)
        onPurchaseRestored?(transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        let productId = transaction.payment.productIdentifier
        onPurchaseFailed?(productId, transaction.error)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // MARK: - Unlock Skin and Save Purchase
    private func unlockSkin(productId: String) {
        savePurchasedSkin(productId: productId)
        NotificationCenter.default.post(name: .skinPurchased, object: productId)
    }
    
    // MARK: - UserDefaults Persistence
    private func savePurchasedSkin(productId: String) {
        var purchasedSkins = getPurchasedSkins()
        if !purchasedSkins.contains(productId) {
            purchasedSkins.append(productId)
            UserDefaults.standard.set(purchasedSkins, forKey: purchasedKey)
        }
    }
    
    func getPurchasedSkins() -> [String] {
        return UserDefaults.standard.stringArray(forKey: purchasedKey) ?? []
    }
    
    func isSkinPurchased(_ productId: String) -> Bool {
        return getPurchasedSkins().contains(productId)
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let skinPurchased = Notification.Name("skinPurchased")
    static let skinsLoaded = Notification.Name("skinsLoaded")
}
