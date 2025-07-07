//
//  ProductDetailViewController.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let detailView = ProductDetailView()
    private let viewModel: ProductDetailViewModel
    private let imageLoader: ImageLoaderProtocol

    init(viewModel: ProductDetailViewModel, imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.product.name
        updateFavoriteIcon()
        detailView.addToCartButton.addTarget(self, action: #selector(addToCartPressed), for: .touchUpInside)
        detailView.favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        detailView.configure(with: viewModel.product, imageLoader: imageLoader)
    }
    
    private func updateFavoriteIcon() {
        let isFavorite = FavoriteStorageManager.shared.isFavorite(id: viewModel.product.id)
        detailView.updateFavoriteIcon(isFavorite: isFavorite)
    }
    
    @objc private func addToCartPressed() {
        CartStorageManager.shared.addToCart(product: self.viewModel.product)
    }
    
    @objc private func favoriteTapped() {
        FavoriteStorageManager.shared.toggleFavorite(product: self.viewModel.product)
        self.updateFavoriteIcon()
    }
}
