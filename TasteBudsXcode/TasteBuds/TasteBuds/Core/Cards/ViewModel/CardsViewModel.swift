//
//  CardsViewModel.swift
//  TinderTemplate
//
//  Created by Ali on 11/04/24.
//

import Foundation

class CardsViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var ButtonSwipeAction: SwipeAction?

    private let recipeFetcher = RecipeFetcher() // Use RecipeFetcher instead of CardService
    
    init() {
        Task {
            await fetchCardModels()
        }
    }
    
    func fetchCardModels() async {
        await recipeFetcher.fetchRecipes() // Ensure recipes are fetched first
        
        DispatchQueue.main.async {
            // Map fetched recipes to cardModels
            self.cardModels = self.recipeFetcher.recipes.map { fetchedRecipe in
                CardModel(recipe: Recipe(
                    id: fetchedRecipe.id,
                    title: fetchedRecipe.title,
                    body: fetchedRecipe.body,
                    createdAt: fetchedRecipe.createdAt,
                    time: fetchedRecipe.time,
                    diets: fetchedRecipe.diets
                ))
            }
        }
    }

    // func removeCard(_ card: CardModel){
        
    // }
}