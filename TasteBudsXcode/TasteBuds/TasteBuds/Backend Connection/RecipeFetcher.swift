// Hannah Haggerty and Alyssa 
import Foundation

struct FetchedRecipe: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let ingredients: String
    let ingredientsRawStr: String
    let servingSize: String
    let servings: Int
    let steps: String
    let tags: String
    let search_terms: String
   // let createdAt: String
   // let time: Int
   // let diets: [FetchedDiet]
    let recipeImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case ingredients
        case ingredientsRawStr = "ingredients_raw_str"
        case servingSize = "serving_size"
        case servings
        case steps
        case tags
        case search_terms
       // case createdAt = "created_at"
       // case time
       // case diets
        case recipeImage = "image_url" //JSON key "image_url" to the `recipeImage`
    }
}



struct FetchedDiet: Decodable {
    let id: Int
    let name: String
}

// The RecipeFetcher class
class RecipeFetcher: ObservableObject {
    @Published var currentRecipe: FetchedRecipe?

    // Fetch recipe from API
    func fetchRecipe() async {
        print("Starting recipe fetch...")

        guard let url = URL(string: "http://127.0.0.1:8000/api/random_recipe/") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            let decodedRecipe = try JSONDecoder().decode(FetchedRecipe.self, from: data)
            DispatchQueue.main.async {
                self.currentRecipe = decodedRecipe
                print("Fetched recipe: \(decodedRecipe.name)")
            }
        } catch {
            print("Error decoding recipe: \(error)")
        }
    }
    
    // Fetch recipes filtered by tags
    func fetchFilteredRecipes(tags: [String]) async {
        print("Fetching filtered recipes...")

        let tagsQuery = tags.map { "tags=\($0)" }.joined(separator: "&")
        let urlString = "http://127.0.0.1:8000/api/filter_recipes/?" + tagsQuery

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            let decodedRecipe = try JSONDecoder().decode(FetchedRecipe.self, from: data)
            DispatchQueue.main.async {
                self.currentRecipe = decodedRecipe
                print("Fetched random filtered recipe: \(decodedRecipe.name)")
                
            }
        } catch {
            print("Error decoding filtered recipes: \(error)")
        }
    }

    // Simple test method to fetch and print a recipe
    func testFetchRecipe() async {
        print("Running fetch recipe test...")

        await fetchRecipe()  // Call the actual fetch function

        if let recipe = currentRecipe {
            print("Test passed. Fetched recipe: \(recipe.name)")
            print("Recipe Body: \(recipe.description)")
        } else {
            print("Test failed. No recipe fetched.")
        }
    }
}
