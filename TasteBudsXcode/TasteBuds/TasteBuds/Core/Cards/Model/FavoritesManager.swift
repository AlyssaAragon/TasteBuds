import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    @Published var favoriteRecipes: [FetchedRecipe] = []
    @Published var sharedFavorites: [FetchedRecipe] = []
    @Published var sharedFavoritesError: String? = nil

    private let userFavoritesURL = URL(string: "https://tastebuds.unr.dev/api/savedrecipe/")!
    private let sharedFavoritesURL = URL(string: "https://tastebuds.unr.dev/api/savedrecipe/shared_favorites/")!
    struct SavedRecipeWrapper: Codable, Identifiable {
        let id: Int
        let recipe: FetchedRecipe

        enum CodingKeys: String, CodingKey {
            case id = "savedid"
            case recipe
        }
    }

    // Fetch user’s saved recipes using token refresh logic
    func fetchUserFavorites() {
        performAuthenticatedRequest({
            var request = URLRequest(url: self.userFavoritesURL)
            request.httpMethod = "GET"
            request.setValue("Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
            return request
        }, onSuccess: { [weak self] data, response in
            do {
                let savedWrappers = try JSONDecoder().decode([SavedRecipeWrapper].self, from: data)
                let extractedRecipes = savedWrappers.map { $0.recipe }
                print("Decoded \(extractedRecipes.count) favorite recipes")
                DispatchQueue.main.async {
                    self?.favoriteRecipes = extractedRecipes
                }
            } catch {
                print("Decoding error: \(error)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw response: \(raw)")
                }
            }
        })
    }


    // Reusable request handler with auto token refresh
    private func performAuthenticatedRequest(
        _ requestBuilder: @escaping () -> URLRequest,
        onSuccess: @escaping (Data, HTTPURLResponse) -> Void
    ) {
        var request = requestBuilder()

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }

            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                print("Invalid response or data")
                return
            }

            // Retry request if token expired
            if response.statusCode == 401 {
                print("Access token expired. Attempting to refresh...")
                AuthService.shared.refreshTokenIfNeeded { success in
                    if success {
                        print("Retrying request after token refresh")
                        var retryRequest = requestBuilder()
                        retryRequest.setValue("Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
                        URLSession.shared.dataTask(with: retryRequest) { data, response, error in
                            guard let data = data,
                                  let response = response as? HTTPURLResponse else {
                                print("Retry failed or response invalid")
                                return
                            }
                            onSuccess(data, response)
                        }.resume()
                    } else {
                        print("Token refresh failed, not retrying request")
                    }
                }
                return
            }

            onSuccess(data, response)
        }.resume()
    }

    // Add a recipe to favorites
    func addFavorite(_ recipe: FetchedRecipe) {
        let recipeID = recipe.id

        performAuthenticatedRequest({
            var request = URLRequest(url: self.userFavoritesURL)
            request.httpMethod = "POST"
            request.setValue("Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // ✅ Backend expects "recipe_id"
            let postBody = ["recipe_id": recipeID]
            request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
            return request
        }, onSuccess: { [weak self] data, response in
            print("Add favorite response status: \(response.statusCode)")
            if response.statusCode == 201 || response.statusCode == 200 {
                DispatchQueue.main.async {
                    if !(self?.favoriteRecipes.contains(where: { $0.id == recipeID }) ?? false) {
                        self?.favoriteRecipes.append(recipe)
                    }
                }
            } else {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Backend error: \(jsonString)")
                }
            }
        })
    }


    // Remove a recipe from favorites
    func removeFavorite(_ recipe: FetchedRecipe) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken"), !token.isEmpty else {
            print("No access token found when trying to delete favorite")
            return
        }

        let recipeID = recipe.id

        guard let deleteURL = URL(string: "https://tastebuds.unr.dev/api/savedrecipe/\(recipeID)/") else {
            print("Invalid delete URL")
            return
        }

        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error deleting favorite: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("DELETE favorite response status: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        if let index = self?.favoriteRecipes.firstIndex(where: { $0.id == recipeID }) {
                            self?.favoriteRecipes.remove(at: index)
                        }
                    }
                } else {
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                        print("Backend response: \(jsonString)")
                    }
                }
            }
        }.resume()
    }

    // Fetch shared favorites between user and partner
    func fetchSharedFavorites() {
        guard let token = UserDefaults.standard.string(forKey: "accessToken"), !token.isEmpty else {
            print("No access token found when trying to fetch shared favorites")
            return
        }

        var request = URLRequest(url: sharedFavoritesURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching shared favorites: \(error)")
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                print("No data or invalid response for shared favorites")
                return
            }

            if httpResponse.statusCode != 200 {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                   let errorMsg = json["error"] {
                    DispatchQueue.main.async {
                        self?.sharedFavoritesError = errorMsg
                    }
                }
                return
            }

            do {
                let savedWrappers = try JSONDecoder().decode([SavedRecipeWrapper].self, from: data)
                let extractedRecipes = savedWrappers.map { $0.recipe }
                DispatchQueue.main.async {
                    self?.sharedFavorites = extractedRecipes
                    self?.sharedFavoritesError = nil
                }
            } catch {
                print("Decoding shared favorites failed: \(error)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw shared favorites response: \(raw)")
                }
            }
        }.resume()
    }


    // Remove multiple recipes from favorites locally
    func removeMultipleFavorites(_ recipes: [FetchedRecipe]) {
        favoriteRecipes.removeAll { recipe in
            recipes.contains(where: { $0.id == recipe.id })
        }
    }
}
