import Foundation

struct CardModel {
//    CardModel wraps a FetchedRecipe object to add functionality or transformations without altering the FetchedRecipe structure itself.
    let recipe: FetchedRecipe
    
    var transformedRecipe: Recipe {
//        A computed property that converts the FetchedRecipe into a Recipe using a custom initializer: Recipe(from: recipe).
//        This allows the UI or other parts of the app to work with a clean, UI-friendly Recipe model instead of dealing with raw API data.
        return Recipe(from: recipe)
    }
}

extension CardModel: Identifiable {
    var id: String { return String(recipe.id) }
//    id is derived from recipe.id, ensuring that each CardModel is uniquely identifiable.
}

/* ****NOTES and USAGE****
 
 Ali 12.9.24---
 CardModel.swift focuses on the logic for individual cards.
 If you need to change how individual cards are represented, you only update CardModel.swift.
 CardModel can be used anywhere you need to represent a card, even outside the context of CardsViewModel.
 You can write unit tests for CardModel to ensure transformations and computed properties work correctly.
 
 */
