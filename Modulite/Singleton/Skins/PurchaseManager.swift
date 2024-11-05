import StoreKit

final class PurchaseManager: NSObject, ObservableObject {
    static let shared = PurchaseManager()
    
    @Published var purchasedSkins: Set<String> = []
    
    private override init() {
        super.init()
        fetchPurchasedProducts()
    }
    
    func fetchProducts() async throws -> [Product] {
        let productIDs = ["com.seuapp.skin1", "com.seuapp.skin2"]
        let products = try await Product.products(for: productIDs)
        return products
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
        case .userCancelled, .pending:
            break
        @unknown default:
            break
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
    
    private func handlePurchased(transaction: Transaction) async {
        purchasedSkins.insert(transaction.productID)
        savePurchasedSkins()
        await transaction.finish()
    }
    
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
}

enum PurchaseError: Error {
    case failedVerification
}
