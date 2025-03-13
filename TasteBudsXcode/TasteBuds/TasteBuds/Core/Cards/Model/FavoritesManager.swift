//
//  FavoritesManager.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 12/9/24.
//
// Alyssa , Alicia

import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    @Published var favoriteRecipes: [FetchedRecipe] = []
    
    @AppStorage("favoriteRecipes") private var storedfavoriteRecipes: Data = Data()
    
    init() {
        loadFavoritesData()
    }
    
    func addFavorite(_ recipe: FetchedRecipe) {
        if !favoriteRecipes.contains(where: { $0.id == recipe.id }) {
            favoriteRecipes.append(recipe)
            saveFavoritesData() // ✅ Save after adding
        }
    }

    func removeFavorite(_ recipe: FetchedRecipe) {
        if let index = favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
            favoriteRecipes.remove(at: index)
            saveFavoritesData() // ✅ Save after removing
        }
    }
    
    func removeMultipleFavorites(_ recipes: [FetchedRecipe]) {
        favoriteRecipes.removeAll { recipe in
            recipes.contains(where: { $0.id == recipe.id })
        }
        saveFavoritesData()
        DispatchQueue.main.async {
            self.objectWillChange.send() // ✅ Forces UI update
        }
    }

    
    private func saveFavoritesData() {
        if let encoded = try? JSONEncoder().encode(favoriteRecipes) {
            UserDefaults.standard.set(encoded, forKey: "favoriteRecipes") // ✅ Ensure it's stored persistently
        }
    }

    
    private func loadFavoritesData() {
        if let decoded = try? JSONDecoder().decode([FetchedRecipe].self, from: storedfavoriteRecipes) {
            favoriteRecipes = decoded
        }
    }
}
