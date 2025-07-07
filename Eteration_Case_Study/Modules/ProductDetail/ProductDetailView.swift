//
//  ProductDetailView.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class ProductDetailView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemYellow
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let priceStack = UIStackView(arrangedSubviews: [priceTitleLabel, priceLabel])
        priceStack.axis = .vertical
        priceStack.alignment = .leading
        let stackView = UIStackView(arrangedSubviews: [priceStack, addToCartButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupScrollView()
    }
    
    private func setupScrollView() {
        addSubview(bottomStackView)
        addSubview(scrollView)
        addSubview(favoriteButton)
        
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -16),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with product: ResponseModel.Product, imageLoader: ImageLoaderProtocol) {
        nameLabel.text = product.name
        descriptionLabel.text = product.description
        priceLabel.text = "\(product.price) ₺"
        imageView.image = nil
        
        if let url = URL(string: product.image) {
            imageLoader.loadImage(from: url) { [weak self] image in
                self?.imageView.image = image
            }
        }
    }
    
    func updateFavoriteIcon(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
