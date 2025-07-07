//
//  NetworkManager.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}

final class NetworkManager: NetworkServiceProtocol {
    private let baseURL = "https://5fc9346b2af77700165ae514.mockapi.io"

    func request<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = endpoint.buildURL(baseURL: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }

        task.resume()
    }
}
