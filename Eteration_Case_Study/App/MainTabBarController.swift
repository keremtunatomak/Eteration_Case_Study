//
//  MainTabBarController.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        configureNavigationBarAppearance()
        configureTabBarAppearance()
        configureNavigationBarTitle()
        configureCartBadge()
        observeCartUpdates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupTabs() {
        let productListVC = ProductListViewController(viewModel: ProductListViewModel())
        let cartVC = CartViewController(viewModel: CartViewModel())
        let favoritesVC = FavoritesViewController(viewModel: FavoritesViewModel())
        let profileVC = ProfileViewController(viewModel: ProfileViewModel())

        productListVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        cartVC.tabBarItem = UITabBarItem(title: "Sepet", image: UIImage(systemName: "cart"), tag: 1)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favori", image: UIImage(systemName: "star"), tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)

        viewControllers = [productListVC, cartVC, favoritesVC, profileVC]
    }
    
    private func configureNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "E-Market"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .systemBackground
        titleLabel.textAlignment = .left
        titleLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 44)

        navigationItem.titleView = titleLabel
    }
    
    private func observeCartUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(configureCartBadge), name: .cartUpdated, object: nil)
    }

    @objc private func configureCartBadge() {
        let cartCount = CartStorageManager.shared.fetchCartItems().reduce(0) { $0 + Int($1.quantity) }

        let badgeValue = cartCount > 0 ? "\(cartCount)" : nil
        viewControllers?[1].tabBarItem.badgeValue = badgeValue
    }
    
    private func configureNavigationBarAppearance() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]

        let backImage = UIImage(systemName: "arrow.backward")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = .systemBackground
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
