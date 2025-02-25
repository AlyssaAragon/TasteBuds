//
//  UserFetcher.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 12/9/24.
// This isn't fully functioning yet
import SwiftUI
class UserFetcher: ObservableObject {
    @Published var currentUser: FetchedUser?

    func fetchUser() async {
        print("Starting user fetch...")

        guard let url = URL(string: "https://tastebuds.unr.dev/api/user_profile/") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Token YOUR_TOKEN_HERE", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            let decodedUser = try JSONDecoder().decode(FetchedUser.self, from: data)
            DispatchQueue.main.async {
                self.currentUser = decodedUser
                print("Fetched user: \(decodedUser.username)")
            }
        } catch {
            print("Error decoding user: \(error)")
        }
    }

    func testFetchUser() async {
        print("Running fetch user test...")

        await fetchUser()

        if let user = currentUser {
            print("Test passed. Fetched user: \(user.username)")
        } else {
            print("Test failed. No user fetched.")
        }
    }
}
