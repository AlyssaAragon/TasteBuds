import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    @Published var favoriteRecipes: [SavedRecipeWrapper] = []
    @Published var sharedFavorites: [SavedRecipeWrapper] = []
    @Published var sharedFavoritesError: String? = nil

    private let userFavoritesURL = URL(string: "https://tastebuds.unr.dev/api/savedrecipe/")!
    private let sharedFavoritesURL = URL(string: "https://tastebuds.unr.dev/api/savedrecipe/shared_favorites/")!

    struct SavedRecipeWrapper: Decodable, Identifiable, Hashable {
        let id: Int // savedid
        let recipe: FetchedRecipe
        let user: Int // <- add this line

        enum CodingKeys: String, CodingKey {
            case id = "savedid"
            case recipe
            case user
        }
    }


    func fetchUserFavorites() {
        performAuthenticatedRequest({
            var request = URLRequest(url: self.userFavoritesURL)
            request.httpMethod = "GET"
            if let token = AuthService.shared.getAccessToken() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            return request
        }, onSuccess: { [weak self] data, _ in
            do {
                let savedWrappers = try JSONDecoder().decode([SavedRecipeWrapper].self, from: data)
                DispatchQueue.main.async {
                    self?.favoriteRecipes = savedWrappers
                }
            } catch {
                print("Decoding error: \(error)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw response: \(raw)")
                }
            }
        })
    }

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

            if response.statusCode == 401 {
                print("Access token expired. Attempting to refresh...")
                AuthService.shared.refreshTokenIfNeeded { success in
                    if success {
                        print("Retrying request after token refresh")
                        var retryRequest = requestBuilder()
                        if let token = AuthService.shared.getAccessToken() {
                            retryRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                        }
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

    func addFavorite(_ recipe: FetchedRecipe) {
        performAuthenticatedRequest({
            var request = URLRequest(url: self.userFavoritesURL)
            request.httpMethod = "POST"
            if let token = AuthService.shared.getAccessToken() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: ["recipe_id": recipe.id])
            return request
        }, onSuccess: { [weak self] data, response in
            if response.statusCode == 201 || response.statusCode == 200 {
                self?.fetchUserFavorites()
            } else {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Backend error: \(jsonString)")
                }
            }
        })
    }

    func removeFavorite(_ wrapper: SavedRecipeWrapper) {
        guard let token = AuthService.shared.getAccessToken() else {
            print("No access token found when trying to delete favorite")
            return
        }

        let deleteURL = URL(string: "https://tastebuds.unr.dev/api/savedrecipe/\(wrapper.id)/")!
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            if let error = error {
                print("Error deleting favorite: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                DispatchQueue.main.async {
                    self?.favoriteRecipes.removeAll(where: { $0.id == wrapper.id })
                }
            } else {
                print("Deletion failed, response: \(response.debugDescription)")
            }
        }.resume()
    }

    func removeMultipleFavorites(_ wrappers: [SavedRecipeWrapper]) {
        for wrapper in wrappers {
            removeFavorite(wrapper)
        }
    }

    func fetchSharedFavorites() {
        guard let token = AuthService.shared.getAccessToken() else {
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

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse else {
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
                DispatchQueue.main.async {
                    self?.sharedFavorites = savedWrappers
                    self?.sharedFavoritesError = nil
                }
            } catch {
                print("Decoding shared favorites failed: \(error)")
            }
        }.resume()
    }
}
