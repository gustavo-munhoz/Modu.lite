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
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self) // Adiciona o manager como observador
    }
    
    deinit {
        SKPaymentQueue.default().remove(self) // Remove o observador ao finalizar
    }
    
    func fetchAvailableSkins(productIds: [String]) {
        productRequest?.cancel()
        productRequest = SKProductsRequest(productIdentifiers: Set(productIds))
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        availableSkins = response.products
        
        if availableSkins.isEmpty {
            print("Nenhum produto de teste encontrado.")
        }
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
    
    // MARK: - SKPaymentTransactionObserver
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
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        unlockSkin(productId: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let error = transaction.error as NSError? {
            print("Transaction failed: \(error.localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func unlockSkin(productId: String) {
        // Lógica para desbloquear a skin e salvar a compra
        print("Skin desbloqueada para o produto: \(productId)")
    }
}
