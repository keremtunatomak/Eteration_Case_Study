//
//  ProductListViewController.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class ProductListViewController: UIViewController {
    private let viewModel: ProductListViewModel
    private let productListView = ProductListView()
    private let imageLoader: ImageLoaderProtocol = ImageLoader()

    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = productListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNotification()
        bindViewModel()
        productListView.searchBar.delegate = self
        productListView.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        showLoading(true)
        viewModel.fetchProducts(reset: true)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesChanged), name: .favoritesDidChange, object: nil)
    }

    private func setupCollectionView() {
        productListView.collectionView.delegate = self
        productListView.collectionView.dataSource = self
    }

    private func bindViewModel() {
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.showLoading(false)
                self?.productListView.collectionView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showLoading(false)
            }
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            self?.showLoading(isLoading)
        }
    }
    
    @objc private func favoritesChanged(_ notification: Notification) {
        guard let productId = notification.userInfo?["productId"] as? String,
              let index = viewModel.filteredProducts.firstIndex(where: { $0.id == productId }) else { return }
        
        let indexPath = IndexPath(item: index, section: 0)
        productListView.collectionView.reloadItems(at: [indexPath])
    }
    
    @objc private func filterButtonTapped() {
        print("Filter button tapped")
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let product = viewModel.filteredProducts[indexPath.item]
        cell.configure(
            with: product,
            imageLoader: imageLoader)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let numberOfRows: CGFloat = 2
        let spacing: CGFloat = 12
        let sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let totalHorizontalSpacing = sectionInsets.left + sectionInsets.right + spacing * (numberOfColumns - 1)
        let totalVerticalSpacing = sectionInsets.top + sectionInsets.bottom + spacing * (numberOfRows - 1)
        
        let width = (collectionView.bounds.width - totalHorizontalSpacing) / numberOfColumns
        let height = (collectionView.bounds.height - totalVerticalSpacing) / numberOfRows

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadMoreIfNeeded(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = viewModel.filteredProducts[indexPath.item]
        let detailViewModel = ProductDetailViewModel(product: selectedProduct)
        let detailVC = ProductDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showLoading(true)
        viewModel.filter(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

