//
//  ProductListViewModel.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import Foundation
import UIKit

final class ProductListViewModel {
    private let networkService: NetworkServiceProtocol
    
    private(set) var products: [ResponseModel.Product] = []
    private(set) var filteredProducts: [ResponseModel.Product] = []
    var onDataLoaded: (() -> Void)?
    var onError: ((APIError) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private var currentPage = 1
    private var isLoading = false
    private var hasMoreData = true
    
    init(networkService: NetworkServiceProtocol = NetworkManager()) {
        self.networkService = networkService
    }
    
    func fetchProducts(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        onLoadingStateChanged?(true)
        
        if reset {
            currentPage = 1
            hasMoreData = true
        }
        
        let endpoint = ProductListEndpoint(page: currentPage)
        networkService.request(endpoint: endpoint, responseModel: [ResponseModel.Product].self) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let items):
                    if reset {
                        self.products = items
                    } else {
                        self.products += items
                    }
                    self.filteredProducts = self.products
                    self.currentPage += 1
                    self.hasMoreData = !items.isEmpty
                    self.onDataLoaded?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    
    func loadMoreIfNeeded(index: Int) {
        guard index >= filteredProducts.count - 1,
              hasMoreData else { return }
        onLoadingStateChanged?(true)
        fetchProducts()
    }
    
    func filter(with text: String) {
        if text.isEmpty {
            filteredProducts = products
        } else {
            let lowercased = text.lowercased()
            filteredProducts = products.filter { $0.name.lowercased().contains(lowercased) }
        }
        onDataLoaded?()
    }
}
