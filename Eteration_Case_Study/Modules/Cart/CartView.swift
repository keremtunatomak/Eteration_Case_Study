//
//  CartView.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class CartView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total:"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var bottomContainer: UIStackView = {
        let priceStack = UIStackView(arrangedSubviews: [totalLabel, totalAmountLabel])
        priceStack.axis = .vertical
        priceStack.alignment = .leading
        let stack = UIStackView(arrangedSubviews: [priceStack, completeButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Your cart is empty"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(tableView)
        addSubview(bottomContainer)
        addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -16),

            bottomContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
