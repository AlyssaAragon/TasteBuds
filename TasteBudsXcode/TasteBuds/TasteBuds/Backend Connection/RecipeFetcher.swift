// Hannah Haggerty and Alyssa
import Foundation

struct FetchedRecipe: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let ingredients: String
    let instructions: String
    let imageName: String?
    let cleanedIngredients: String
    var assignedTo: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, name, ingredients, instructions
        case imageName = "image_name"
        case cleanedIngredients = "cleaned_ingredients"
    }

    var imageUrl: URL? {
        guard let imageName = imageName else { return nil }
        return URL(string: imageName)
    }
}

struct FetchedDiet: Decodable {
    let id: Int
    let name: String
}

class RecipeFetcher: ObservableObject {
    @Published var currentRecipe: FetchedRecipe?

    func fetchRecipe() async {
        print("Fetching random recipe...")

        guard let url = URL(string: "https://tastebuds.unr.dev/api/random_recipe/") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status: \(httpResponse.statusCode)")
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

    func fetchCombinedRecipe(category: String?, diets: [String]) async {
        var components = URLComponents(string: "https://tastebuds.unr.dev")!

        if let category = category, !diets.isEmpty {
            components.path = "/api/filter_recipes_combined/"
            components.queryItems = [URLQueryItem(name: "category", value: category)]
            components.queryItems?.append(contentsOf: diets.map { URLQueryItem(name: "diet", value: $0) })
        } else if let category = category {
            components.path = "/api/get_random_recipe_by_category/"
            components.queryItems = [URLQueryItem(name: "category", value: category)]
        } else if !diets.isEmpty {
            components.path = "/api/filter_recipes_by_diet/"
            components.queryItems = diets.map { URLQueryItem(name: "diet", value: $0) }
        } else {
            components.path = "/api/random_recipe/"
        }

        guard let url = components.url else {
            print("ERROR: Invalid URL built from category and diet filters")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("DEBUG: Combined recipe fetch status: \(httpResponse.statusCode)")
            }
            let decodedRecipe = try JSONDecoder().decode(FetchedRecipe.self, from: data)
            DispatchQueue.main.async {
                self.currentRecipe = decodedRecipe
                print("✅ Fetched combined recipe: \(decodedRecipe.name)")
            }
        } catch {
            print("ERROR: Failed to decode combined recipe: \(error)")
        }
    }

    func fetchUserDietPreferences(token: String) async -> [String] {
        guard let url = URL(string: "https://tastebuds.unr.dev/api/user_profile/") else {
            print("ERROR: Invalid user profile URL")
            return []
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("DEBUG: User profile response status = \(httpResponse.statusCode)")
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let dietsArray = json["diets"] as? [[String: Any]] {
                let names = dietsArray.compactMap { $0["dietname"] as? String }
                print("✅ Extracted diets from user profile: \(names)")
                return names
            }

            print("DEBUG: No diets found in user profile.")
            return []
        } catch {
            print("ERROR: Failed fetching user diets: \(error)")
            return []
        }
    }

    func testImageFetching() async {
        guard let recipe = currentRecipe, let imageUrlString = recipe.imageName,
              let imageUrl = URL(string: imageUrlString) else {
            print("DEBUG: No valid image name found in currentRecipe.")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: imageUrl)
            if let httpResponse = response as? HTTPURLResponse {
                print("DEBUG: Image fetch status: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200, !data.isEmpty {
                    print("✅ Image successfully fetched. Size: \(data.count) bytes")
                } else {
                    print("❌ Image fetch failed or empty.")
                }
            }
        } catch {
            print("ERROR: Failed fetching image: \(error.localizedDescription)")
        }
    }
}
