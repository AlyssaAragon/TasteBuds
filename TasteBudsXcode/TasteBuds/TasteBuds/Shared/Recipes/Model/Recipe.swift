struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let time: Int
    let recipeDescription: String
    let diets: [String]
    let recipeImage: String?

    init(from fetchedRecipe: FetchedRecipe) {
        self.id = fetchedRecipe.id
        self.title = fetchedRecipe.title
        self.time = fetchedRecipe.time
        self.recipeDescription = fetchedRecipe.body
        self.diets = fetchedRecipe.diets.map { $0.name }
        self.recipeImage = fetchedRecipe.recipeImage
    }
}
