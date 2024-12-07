//
//  CardsViewModel.swift
//  TinderTemplate
//
//  Created by Ali on 11/04/24.
//

import Foundation

class CardsViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var buttonSwipeAction: SwipeAction? = nil

    private let recipeFetcher: RecipeFetcher
    
    init(recipeFetcher: RecipeFetcher) {
            self.recipeFetcher = recipeFetcher
            Task {
                await fetchRecipes()
        }
    }

    func fetchRecipes() async {
        await recipeFetcher.fetchRecipes()
        DispatchQueue.main.async {
            self.cardModels = self.recipeFetcher.recipes.map { CardModel(recipe: Recipe(from: $0)) }
        }
    }
}

//    init() {
//        Task {
//            await fetchCardModels()
//        }
//    }
//    
//    func fetchCardModels() async {
//        await recipeFetcher.fetchRecipes() // Ensure recipes are fetched first
//        
//        DispatchQueue.main.async {
//            // Map fetched recipes to cardModels
//            self.cardModels = self.recipeFetcher.recipes.map { fetchedRecipe in
//                CardModel(recipe: Recipe(
//                    id: fetchedRecipe.id,
//                    title: fetchedRecipe.title,
//                    body: fetchedRecipe.body,
//                    createdAt: fetchedRecipe.createdAt,
//                    time: fetchedRecipe.time,
//                    diets: fetchedRecipe.diets
//                ))
//            }
//        }
//    }
//
//    // func removeCard(_ card: CardModel){
//        
//    // }
//}
