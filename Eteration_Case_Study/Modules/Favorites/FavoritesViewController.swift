//
//  FavoritesViewController.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    private let favoritesView = FavoritesView()
    private let imageLoader: ImageLoaderProtocol

    init(viewModel: FavoritesViewModel, imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func loadView() {
        view = favoritesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesView.collectionView.delegate = self
        favoritesView.collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
        
        viewModel.loadFavorites()
        
        viewModel.onReload = { [weak self] in
            guard let self else { return }
            let isEmpty = self.viewModel.favorites.isEmpty
            DispatchQueue.main.async {
                self.showLoading(false)
                self.favoritesView.collectionView.isHidden = isEmpty
                self.favoritesView.emptyLabel.isHidden = !isEmpty
                self.favoritesView.collectionView.reloadData()
            }
        }
    }
    
    @objc private func favoritesDidChange() {
        showLoading(true)
        viewModel.loadFavorites()
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }

        let product = viewModel.favorites[indexPath.item]
        cell.configure(with: product, imageLoader: imageLoader)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = viewModel.favorites[indexPath.item]
        let detailVM = ProductDetailViewModel(product: selected)
        let detailVC = ProductDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
