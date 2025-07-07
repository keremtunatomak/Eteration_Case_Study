//
//  ImageLoader.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoader: ImageLoaderProtocol {
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
