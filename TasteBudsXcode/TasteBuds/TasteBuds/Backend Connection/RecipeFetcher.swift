// Hannah Haggerty and Alyssa
import Foundation

struct FetchedRecipe: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let ingredients: String
    let instructions: String
    let imageName: String?
    let cleanedIngredients: String
    var assignedTo: [Int]? // User IDs assigned to this recipe

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

    // Fetch a random recipe from the API
    func fetchRecipe() async {
        print("Fetching recipe...")

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
    
    // Fetch filtered recipes based on tags
    func fetchFilteredRecipes(tags: [String]) async {
        print("Fetching filtered recipes...")

        let tagsQuery = tags.map { "tags=\($0)" }.joined(separator: "&")
        let urlString = "https://tastebuds.unr.dev/api/filter_recipes/?" + tagsQuery

        guard let url = URL(string: urlString) else {
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
                print("Fetched filtered recipe: \(decodedRecipe.name)")
            }
        } catch {
            print("Error decoding filtered recipes: \(error)")
        }
    }

    // Test function to verify recipe fetching
    func testFetchRecipe() async {
        print("Testing recipe fetch...")
        await fetchRecipe()

        if let recipe = currentRecipe {
            print("Test successful. Fetched recipe: \(recipe.name)")
        } else {
            print("Test failed. No recipe fetched.")
        }
    }

    // Test function to verify image fetching
    func testImageFetching() async {
        print("Testing image fetching...")

        await fetchRecipe()

        if let recipe = currentRecipe, let imageUrlString = recipe.imageName,
           let imageUrl = URL(string: imageUrlString) {
            print("Constructed image URL: \(imageUrl.absoluteString)")

            do {
                let (data, response) = try await URLSession.shared.data(from: imageUrl)

                if let httpResponse = response as? HTTPURLResponse {
                    print("Image response status: \(httpResponse.statusCode)")

                    if httpResponse.statusCode == 200, !data.isEmpty {
                        print("Image successfully fetched. Size: \(data.count) bytes")
                    } else {
                        print("Image URL returned status \(httpResponse.statusCode) or empty data.")
                    }
                }
            } catch {
                print("Error fetching image: \(error.localizedDescription)")
            }
        } else {
            print("No valid image_name found in the fetched recipe.")
        }
    }
}
