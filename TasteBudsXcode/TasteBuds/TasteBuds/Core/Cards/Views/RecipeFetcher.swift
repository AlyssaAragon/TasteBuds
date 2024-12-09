import Foundation
struct FetchedRecipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let body: String
    let createdAt: String
    let time: Int
    let diets: [FetchedDiet]
    let recipeImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case createdAt = "created_at"
        case time
        case diets
        case recipeImage = "image_url" //JSON key "image_url" to the `recipeImage`
    }
}

// Represents the dietary information associated with a recipe
struct FetchedDiet: Decodable {
    let id: Int
    let name: String
}

//recipeFetcher that gets recipes from the backend
class RecipeFetcher: ObservableObject {
    @Published var currentRecipe: FetchedRecipe? //stores only one recipe at a time

    //Fetch one recipe at a time
    func fetchRecipe() async {
        print("Starting recipe fetch...")

        //API endpoint for fetching a single random recipe
        guard let url = URL(string: "http://127.0.0.1:8000/api/random_recipe/") else {
            print("Invalid URL")
            return
        }

        do {
            // Fetch data from the server
            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            let decodedRecipe = try JSONDecoder().decode(FetchedRecipe.self, from: data)
            DispatchQueue.main.async {
                self.currentRecipe = decodedRecipe
                print("Fetched recipe: \(decodedRecipe.title)")
            }

        } catch {
            print("Error decoding recipe: \(error)")
        }
    }
}
