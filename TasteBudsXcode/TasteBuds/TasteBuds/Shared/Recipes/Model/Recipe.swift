//  Recipe.swift

import Foundation

struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let time: Int
    let recipeDescription: String
    let diets: [String]
    let recipeImage: String?
    
    init(from fetchedRecipe: FetchedRecipe) {
        self.id = Int(fetchedRecipe.id)
        self.title = fetchedRecipe.title
        self.time = fetchedRecipe.time
        self.recipeDescription = fetchedRecipe.body
        self.diets = fetchedRecipe.diets.map { $0.name }
        self.recipeImage = recipeImage ?? "placeholder"
    }
}
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case body
//        case createdAt = "created_at" 
//        case time
//        case diets
//    }
//}
//
//struct Diet: Decodable {
//    let id: Int
//    let name: String
//}
