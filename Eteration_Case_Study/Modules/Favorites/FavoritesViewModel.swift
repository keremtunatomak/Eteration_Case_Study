//
//  FavoritesViewModel.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import Foundation

final class FavoritesViewModel {
    private(set) var favorites: [ResponseModel.Product] = []
    var onReload: (() -> Void)?

    func loadFavorites() {
        favorites = FavoriteStorageManager.shared.fetchFavorites()
        onReload?()
    }
}
