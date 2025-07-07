//
//  ResponseModel.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 6.07.2025.
//

struct ResponseModel {
    struct Product: Decodable {
        let id: String
        let name: String
        let image: String
        let price: String
        let description: String
        let brand: String
        let model: String
    }
}
