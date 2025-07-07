//
//  CartViewModel.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import Foundation

final class CartViewModel {
    private(set) var items: [CartItemEntity] = []
    var onCartChanged: (() -> Void)?

    func loadCart() {
        items = CartStorageManager.shared.fetchCartItems()
        onCartChanged?()
    }

    func increaseQuantity(for item: CartItemEntity) {
        let newQty = item.quantity + 1
        CartStorageManager.shared.updateQuantity(id: item.id ?? "", quantity: newQty)
        loadCart()
    }

    func decreaseQuantity(for item: CartItemEntity) {
        if item.quantity <= 1 {
            CartStorageManager.shared.removeItem(id: item.id ?? "")
        } else {
            CartStorageManager.shared.updateQuantity(id: item.id ?? "", quantity: item.quantity - 1)
        }
        loadCart()
    }

    func removeItem(_ item: CartItemEntity) {
        CartStorageManager.shared.removeItem(id: item.id ?? "")
        loadCart()
    }
    
    func totalPriceString() -> String {
        let total = items.reduce(0.0) { result, item in
            let price = Double(item.price ?? "0") ?? 0
            return result + price * Double(item.quantity)
        }
        return String(format: "%.2f", total)
    }
}
