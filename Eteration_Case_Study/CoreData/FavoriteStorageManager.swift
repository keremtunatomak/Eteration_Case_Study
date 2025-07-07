//
//  FavoriteStorageManager.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 7.07.2025.
//

import CoreData

final class FavoriteStorageManager {
    
    static let shared = FavoriteStorageManager()
    private let context = CoreDataStack.shared.context
    
    func isFavorite(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return (try? context.count(for: fetchRequest)) ?? 0 > 0
    }
    
    func toggleFavorite(product: ResponseModel.Product) {
        if isFavorite(id: product.id) {
            removeFavorite(id: product.id)
        } else {
            let entity = FavoriteEntity(context: context)
            entity.id = product.id
            entity.name = product.name
            entity.image = product.image
            entity.price = product.price
            try? context.save()
        }
        
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil, userInfo: ["productId": product.id])
    }
    
    func removeFavorite(id: String) {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        guard let result = try? context.fetch(fetchRequest),
              let objectToDelete = result.first else { return }
        
        context.delete(objectToDelete)
        try? context.save()
    }
    
    func fetchFavorites() -> [ResponseModel.Product] {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        guard let results = try? context.fetch(fetchRequest) else {
            return []
        }
        return results.map {
            ResponseModel.Product(
                id: $0.id ?? "",
                name: $0.name ?? "",
                image: $0.image ?? "",
                price: $0.price ?? "",
                description: "",
                brand: "",
                model: ""
            )
        }
    }
}
