//
//  CardService.swift
//  TasteBuds
//
//  Created by Ali on 11/04/24.
//

import Foundation

struct CardService{
    func fetchCardModels() async throws -> [CardModel] {
        let recipes = MockData.recipes
        return recipes.map({CardModel(recipe:$0)})
    }
}
