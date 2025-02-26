import Foundation
import Combine

class FavoritesManager: ObservableObject {
    @Published var favoriteRecipes: [FetchedRecipe] = []
    @Published var sharedFavoriteRecipes: [FetchedRecipe] = []

    let userId: String
    let partnerId: String?
    private let baseURL = "https://tastebuds.unr.dev/api/saved_recipes/"

    init(userId: String, partnerId: String? = nil) {
        self.userId = userId
        self.partnerId = partnerId
        fetchFavorites()
        if partnerId != nil {
            fetchSharedFavorites()
        }
    }

    func fetchFavorites() {
        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let fetchedRecipes = try JSONDecoder().decode([FetchedRecipe].self, from: data)
                    DispatchQueue.main.async {
                        self.favoriteRecipes = fetchedRecipes
                    }
                } catch {
                    print("Failed to decode favorite recipes: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Failed to fetch favorite recipes: \(error.localizedDescription)")
            }
        }.resume()
    }

    func addFavorite(_ recipe: FetchedRecipe) {
        guard !favoriteRecipes.contains(where: { $0.id == recipe.id }) else { return }
        favoriteRecipes.append(recipe)

        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["user": userId, "recipe": recipe.id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Failed to add favorite: \(error.localizedDescription)")
            }
        }.resume()
    }

    func removeFavorite(_ recipe: FetchedRecipe) {
        guard let savedRecipeId = favoriteRecipes.first(where: { $0.id == recipe.id })?.id else { return }
        favoriteRecipes.removeAll { $0.id == recipe.id }

        guard let url = URL(string: "\(baseURL)\(savedRecipeId)/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Failed to remove favorite: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchSharedFavorites() {
        guard let partnerId = partnerId else { return }
        guard let url = URL(string: "\(baseURL)shared_favorites/?partner_id=\(partnerId)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let sharedRecipes = try JSONDecoder().decode([FetchedRecipe].self, from: data)
                    DispatchQueue.main.async {
                        self.sharedFavoriteRecipes = sharedRecipes
                    }
                } catch {
                    print("Failed to decode shared favorite recipes: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Failed to fetch shared favorite recipes: \(error.localizedDescription)")
            }
        }.resume()
    }
}
