import Foundation

struct CardModel {
    let recipe: FetchedRecipe
    var transformedRecipe: Recipe {
        return Recipe(from: recipe)
    }
}

extension CardModel: Identifiable {
    var id: String { return String(recipe.id) }
}
