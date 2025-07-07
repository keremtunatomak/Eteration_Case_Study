//
//  CartViewController.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class CartViewController: UIViewController {
    
    private let cartView = CartView()
    private let viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = cartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        showLoading(true)
        viewModel.loadCart()
        NotificationCenter.default.addObserver(self, selector: #selector(cartChanged), name: .cartUpdated, object: nil)
    }
    
    private func setupTableView() {
        cartView.tableView.delegate = self
        cartView.tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.onCartChanged = { [weak self] in
            guard let self else { return }
            
            let isEmpty = viewModel.items.isEmpty
            DispatchQueue.main.async {
                self.showLoading(false)
                self.cartView.tableView.isHidden = isEmpty
                self.cartView.bottomContainer.isHidden = isEmpty
                self.cartView.emptyLabel.isHidden = !isEmpty
                
                self.cartView.tableView.reloadData()
                self.cartView.totalAmountLabel.text = "\(self.viewModel.totalPriceString()) ₺"
            }
        }
    }
    
    @objc private func cartChanged() {
        showLoading(true)
        viewModel.loadCart()
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        cell.delegate = self
        return cell
    }
}

extension CartViewController: CartItemCellDelegate {
    func increaseQuantity(for item: CartItemEntity) {
        viewModel.increaseQuantity(for: item)
    }
    
    func decreaseQuantity(for item: CartItemEntity) {
        viewModel.decreaseQuantity(for: item)
    }
}
