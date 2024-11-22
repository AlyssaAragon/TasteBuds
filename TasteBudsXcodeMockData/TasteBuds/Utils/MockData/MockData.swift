//
//  MockData.swift
//  TasteBuds
//
//  Created by Ali on 11/04/24.
//

import Foundation

struct MockData {
    static let recipes: [Recipe] = [
        .init(
            id: NSUUID().uuidString,
            name: "Avgolemono",
            time: 1,
            recipeDescription: "Chicken Lemon Rice Soup",
            recipeImage: ["avgolemono"]
        ),
        .init(
            id: NSUUID().uuidString,
            name: "California Roll",
            time: 1,
            recipeDescription: "Sushi roll, no raw meat",
            recipeImage: ["californiaRoll"]
        ),
        .init(
            id: NSUUID().uuidString,
            name: "Beef Burger",
            time: 1,
            recipeDescription: "burgah",
            recipeImage: ["beefBurger"]
        )
    ]
}

