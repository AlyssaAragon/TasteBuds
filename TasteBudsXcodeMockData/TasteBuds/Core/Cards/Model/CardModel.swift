//
//  CardModel.swift
//  TinderTemplate
//
//  Created by Ali on 11/14/24.
//

import Foundation

struct CardModel {
    let recipe: Recipe
}

extension CardModel: Identifiable {
    var id: String { return recipe.id }
}
