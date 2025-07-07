//
//  CartItemCell.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 7.07.2025.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func increaseQuantity(for item: CartItemEntity)
    func decreaseQuantity(for item: CartItemEntity)
}

final class CartItemCell: UITableViewCell {
    
    static let identifier = "CartItemCell"
    weak var delegate: CartItemCellDelegate?
    private var item: CartItemEntity?
    
    private lazy var nameLabel = UILabel()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.backgroundColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [decreaseButton, quantityLabel, increaseButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let left = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        left.axis = .vertical
        let main = UIStackView(arrangedSubviews: [left, quantityStack])
        main.axis = .horizontal
        main.distribution = .equalSpacing
        main.alignment = .center
        main.spacing = 8
        main.translatesAutoresizingMaskIntoConstraints = false
        return main
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentStack)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(with item: CartItemEntity) {
        self.item = item
        nameLabel.text = item.name
        priceLabel.text = "\(item.price ?? "") ₺"
        quantityLabel.text = "\(item.quantity)"
    }
    
    @objc private func increaseTapped() {
        guard let item else { return }
        delegate?.increaseQuantity(for: item)
    }
    
    @objc private func decreaseTapped() {
        guard let item else { return }
        delegate?.decreaseQuantity(for: item)
    }
}
