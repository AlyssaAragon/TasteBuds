// Hannah Haggerty and Alicia Chiang
struct Recipe: Identifiable {
    let id: Int
    let title: String
    let recipeImage: String?

    init(from fetchedRecipe: FetchedRecipe) {
        self.id = fetchedRecipe.id
        self.title = fetchedRecipe.name
        self.recipeImage = fetchedRecipe.imageName
    }
}
