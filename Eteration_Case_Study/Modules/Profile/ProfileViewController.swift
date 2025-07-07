//
//  ProfileViewController.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    private let profileView = ProfileView()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
