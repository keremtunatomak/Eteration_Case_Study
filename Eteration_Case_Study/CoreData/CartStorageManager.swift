//
//  CartStorageManager.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 7.07.2025.
//

import CoreData
import UIKit

final class CartStorageManager {
    
    static let shared = CartStorageManager()
    private let context = CoreDataStack.shared.context

    func addToCart(product: ResponseModel.Product) {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
        
        if let result = try? context.fetch(fetchRequest), let existingItem = result.first {
            existingItem.quantity += 1
        } else {
            let newItem = CartItemEntity(context: context)
            newItem.id = product.id
            newItem.name = product.name
            newItem.image = product.image
            newItem.price = product.price
            newItem.quantity = 1
        }

        try? context.save()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func removeItem(id: String) {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let items = try? context.fetch(request), let item = items.first else { return }
        
        context.delete(item)
        try? context.save()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func updateQuantity(id: String, quantity: Int16) {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let items = try? context.fetch(request), let item = items.first else { return }
        
        item.quantity = quantity
        try? context.save()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func fetchCartItems() -> [CartItemEntity] {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
}
