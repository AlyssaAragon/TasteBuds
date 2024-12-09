import Foundation

struct FetchedRecipe: Identifiable, Decodable { // represents a single recipe fetched from the server
    let id: Int
    let title: String
    let body: String
    let createdAt: String
    let time: Int
    let diets: [FetchedDiet]
    let recipeImage: String?  // Add this line for recipeImage

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case createdAt = "created_at"
        case time
        case diets
        case recipeImage = "image_url" // Map the JSON key "image_url" to the `recipeImage` property
    }
}

struct FetchedDiet: Decodable { // represents the dietary information associated with a recipe
    let id: Int
    let name: String
}

// RecipeFetcher that gets recipes from the backend
class RecipeFetcher: ObservableObject {
    @Published var recipes: [FetchedRecipe] = []
    
    func fetchRecipes() async {
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
                self.recipes = [decodedRecipe]
                print("Fetched recipe: \(decodedRecipe.title)")
                
            }
        } catch {
            print("Error decoding recipes: \(error)")
        }
    }
}
