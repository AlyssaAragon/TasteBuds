//  Recipe.swift

import Foundation

struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let body: String
    let createdAt: String
    let time: Int
    let diets: [Diet]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case createdAt = "created_at" 
        case time
        case diets
    }
}

struct Diet: Decodable {
    let id: Int
    let name: String
}
