//
//  ProductCollectionViewCell.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCollectionViewCell"
    private var imageLoader: ImageLoaderProtocol?
    private var product: ResponseModel.Product?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, priceLabel, nameLabel, addToCartButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemYellow
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 6
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(stackView)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(with product: ResponseModel.Product, imageLoader: ImageLoaderProtocol) {
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) ₺"
        imageView.image = nil
        self.product = product
        self.imageLoader = imageLoader
        updateFavoriteState()
        
        if let url = URL(string: product.image) {
            imageLoader.loadImage(from: url) { [weak self] image in
                self?.imageView.image = image
            }
        }
    }
    
    private func updateFavoriteState() {
        guard let product else { return }
        let isFav = FavoriteStorageManager.shared.isFavorite(id: product.id)
        let imageName = isFav ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func favoriteTapped() {
        guard let product else { return }
        FavoriteStorageManager.shared.toggleFavorite(product: product)
        updateFavoriteState()
    }
    
    @objc private func addToCartTapped() {
        guard let product else { return }
        CartStorageManager.shared.addToCart(product: product)
    }
}
