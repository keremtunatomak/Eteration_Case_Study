//
//  Endpoint.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    func buildURL(baseURL: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path += path
        components?.queryItems = queryItems
        return components?.url
    }
}

struct ProductListEndpoint: Endpoint {
    let page: Int
    
    var path: String { "/products" }
    var method: String { "GET" }
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "4")
        ]
    }
}
