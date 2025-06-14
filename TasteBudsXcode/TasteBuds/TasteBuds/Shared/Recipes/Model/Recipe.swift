struct Recipe: Identifiable, Codable {
    let id: Int
    let title: String
    let recipeImage: String?

    init(from fetchedRecipe: FetchedRecipe) {
        self.id = fetchedRecipe.id
        self.title = fetchedRecipe.name
        self.recipeImage = fetchedRecipe.imageName
        print("DEBUG: Creating Recipe — title: \(title), imageName: \(String(describing: recipeImage))")
    }
}
