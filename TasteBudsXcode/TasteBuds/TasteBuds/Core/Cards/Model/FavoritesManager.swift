//
//  FavoritesManager.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 12/9/24.
//
// Alyssa 
import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteRecipes: [FetchedRecipe] = []

    func addFavorite(_ recipe: FetchedRecipe) {
        if !favoriteRecipes.contains(where: { $0.id == recipe.id }) {
            favoriteRecipes.append(recipe)
        }
    }

    func removeFavorite(_ recipe: FetchedRecipe) {
        if let index = favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
            favoriteRecipes.remove(at: index)
        }
    }
}
