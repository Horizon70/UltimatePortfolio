//
//  DataController-StoreKit.swift
//  UltimatePortfolio
//
//  Created by Davide Fabretti on 27/07/24.
//

import Foundation
import StoreKit

extension DataController {
    /// The product ID for our premium unlock
    static let unlockPremiumProductID = "com.davidefabretti.UltimatePortfolio.premiumUnlock"
    
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
        
        set {
            defaults.setValue(newValue, forKey: "fullVersionUnlocked")
        }
    }
    
    func monitorTransactions() async {
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement {
                await finalize(transaction)
            }
        }
        
        for await update in Transaction.updates {
            if let transaction = try? update.payloadValue {
                await finalize(transaction)
            }
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        if case let .success(validation) = result {
            try await finalize(validation.payloadValue)
        }
    }
    
    @MainActor
    func finalize(_ transaction: Transaction) async {
        if transaction.productID == Self.unlockPremiumProductID {
            objectWillChange.send()
            fullVersionUnlocked = transaction.revocationDate == nil
            await transaction.finish()
        }
    }
    
    @MainActor
    func loadProducts() async throws {
        guard products.isEmpty else { return }
        
        try await Task.sleep(for: .seconds(0.2))
        products = try await Product.products(for: [Self.unlockPremiumProductID])
    }
}
