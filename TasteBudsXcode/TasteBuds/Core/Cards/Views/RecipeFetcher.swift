import Foundation

// FetchedRecipe model
struct FetchedRecipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let body: String
    let createdAt: String
    let time: Int
    let diets: [Diet]

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

//RecipeFetcher class that gets recipes from the backend
class RecipeFetcher: ObservableObject {
    @Published var recipes: [FetchedRecipe] = []

    func fetchRecipes() {
        guard let url = URL(string: "http://127.0.0.1:8000/allrecipes/") else { return }//Django server URL

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recipes: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let decodedRecipes = try JSONDecoder().decode([FetchedRecipe].self, from: data)
                DispatchQueue.main.async {
                    self.recipes = decodedRecipes
                }
            } catch {
                print("Error decoding recipes: \(error)")
            }
        }.resume()
    }
}
