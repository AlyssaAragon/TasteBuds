//
//  Recipe.swift
//  TasteBuds
//
//  Created by Ali on 11/04/24.
//

import Foundation

struct Recipe: Identifiable{
    let id: String
    let name: String
    var time: Int
    let recipeDescription: String
    var recipeImage: [String]
}
