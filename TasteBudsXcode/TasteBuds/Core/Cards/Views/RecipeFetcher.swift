import Foundation

// FetchedRecipe model
struct FetchedRecipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let body: String
    let createdAt: String
    let time: Int
    let diets: [FetchedDiet]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case createdAt = "created_at"
        case time
        case diets
    }
}

struct FetchedDiet: Decodable {
    let id: Int
    let name: String
}

//RecipeFetcher that gets recipes from the backend
class RecipeFetcher: ObservableObject {
    @Published var recipes: [FetchedRecipe] = []

    func fetchRecipes() {
        print("Starting recipe fetch...") // Log the fetch start
        guard let url = URL(string: "http://127.0.0.1:8000/admin/tastebuds/allrecipe/") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recipes: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedRecipes = try JSONDecoder().decode([FetchedRecipe].self, from: data)
                DispatchQueue.main.async {
                    self.recipes = decodedRecipes
                    print("Fetched recipes count: \(self.recipes.count)") //how many recipes were fetched
                    for recipe in self.recipes {
                        print("Recipe title: \(recipe.title)") //log each recipe title
                    }
                }
            } catch {
                print("Error decoding recipes: \(error)")
            }
        }.resume()
    }
    
}
