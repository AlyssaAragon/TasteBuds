struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let time: Int
    let recipeDescription: String
    let diets: [String]
    let recipeImage: String? // Make this optional

    init(from fetchedRecipe: FetchedRecipe) {
        self.id = Int(fetchedRecipe.id)
        self.title = fetchedRecipe.title
        self.time = fetchedRecipe.time
        self.recipeDescription = fetchedRecipe.body
        self.diets = fetchedRecipe.diets.map { $0.name }
        self.recipeImage = fetchedRecipe.recipeImage // Keep it optional
    }
}
