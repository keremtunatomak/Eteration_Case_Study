//
//  UIViewController+Extension.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 7.07.2025.
//

import UIKit

extension UIViewController {
    
    /// Yalnızca bu extension içinde geçerli bir tag tanımı
    private var loadingViewTag: Int { return 9999 }

    /// Loading görünümünü gösterir veya gizler
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            // Eğer daha önce eklenmişse tekrar ekleme
            if view.viewWithTag(loadingViewTag) != nil {
                return
            }

            let loadingView = LoadingView()
            loadingView.tag = loadingViewTag
            loadingView.frame = view.bounds
            loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            loadingView.startAnimating(in: view)
        } else {
            // Ekli loadingView varsa çıkar
            guard let loadingView = view.viewWithTag(loadingViewTag) as? LoadingView else { return }
            loadingView.stopAnimating()
        }
    }
}
