//
//  APIError.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unknown
}
