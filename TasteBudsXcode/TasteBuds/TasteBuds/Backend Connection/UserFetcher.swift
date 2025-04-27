import SwiftUI
import SwiftKeychainWrapper

@MainActor
class UserFetcher: ObservableObject {
    @Published var currentUser: FetchedUser?
    @Published var sessionExpired: Bool = false

    func fetchUser() async {
        print("Starting user fetch...")

        do {
            // Step 1: Ensure token is valid or refresh it
            try await AuthService.shared.ensureValidToken()

            // Step 2: Get access token from Keychain
            guard let accessToken = AuthService.shared.getAccessToken() else {
                print("No access token found even after refresh.")
                sessionExpired = true
                return
            }

            // Step 3: Build request with Authorization header
            guard let url = URL(string: "https://tastebuds.unr.dev/api/user_profile/") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

            // Step 4: Fetch and decode user
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("User fetch status: \(httpResponse.statusCode)")

                if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                    print("Unauthorized — session expired.")
                    sessionExpired = true
                    return
                }
            }

            let decodedUser = try JSONDecoder().decode(FetchedUser.self, from: data)
            self.currentUser = decodedUser
            UserDefaults.standard.set(decodedUser.userid, forKey: "userID")
            print("Fetched user: \(decodedUser.username) with ID: \(decodedUser.userid)")
        } catch {
            print("Error during fetchUser: \(error)")
            sessionExpired = true
        }
    }

    func reset() {
        currentUser = nil
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
