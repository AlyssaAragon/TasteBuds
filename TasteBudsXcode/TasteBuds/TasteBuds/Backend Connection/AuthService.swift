import Foundation
import SwiftKeychainWrapper

struct AuthResponse: Codable {
    let access: String
    let refresh: String
}

enum AuthError: Error {
    case invalidCredentials
    case userAlreadyExists
    case serverError(String)
    case tokenRefreshFailed
    case decoding(Data)
    case tooManyAttempts 
}


class AuthService {
    static let shared = AuthService()
    private init() {}

    private let baseURL = "https://tastebuds.unr.dev/api"

    // MARK: - Signup
    func signup(email: String, username: String, password: String, fullName: String, confirmPassword: String) async throws {
        guard let url = URL(string: "\(baseURL)/signup/") else {
            throw AuthError.serverError("Invalid signup URL")
        }

        let body: [String: Any] = [
            "email": email,
            "username": username,
            "firstlastname": fullName,
            "password": password,
            "password2": confirmPassword
        ]

        let data = try await sendRequest(url: url, body: body)

        if let responseString = String(data: data, encoding: .utf8)?.lowercased(),
           !responseString.contains("user created") {
            throw AuthError.serverError("Signup failed: \(responseString)")
        }
    }



    // MARK: - Login
    func login(email: String, password: String) async throws {
        guard let url = URL(string: "\(baseURL)/token/") else {
            throw AuthError.serverError("Invalid login URL")
        }

        let body = ["email": email, "password": password]
        let data = try await sendRequest(url: url, body: body)

        let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
        saveTokens(access: decoded.access, refresh: decoded.refresh)
    }

    // MARK: - Refresh Token
    func refreshToken() async throws {
        guard let refresh = KeychainWrapper.standard.string(forKey: "refreshToken"),
              let url = URL(string: "\(baseURL)/token/refresh/") else {
            throw AuthError.tokenRefreshFailed
        }

        let data = try await sendRequest(url: url, body: ["refresh": refresh])
        guard let json = try? JSONDecoder().decode([String: String].self, from: data),
              let newAccess = json["access"] else {
            throw AuthError.tokenRefreshFailed
        }

        KeychainWrapper.standard.set(newAccess, forKey: "accessToken")
    }

    func ensureValidToken() async throws {
        if getAccessToken() == nil {
            try await refreshToken()
        }
    }

    func authorizedRequest(for endpoint: String, method: String = "GET") async throws -> URLRequest {
        try await ensureValidToken()

        guard let access = getAccessToken(),
              let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw AuthError.tokenRefreshFailed
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")
        return request
    }

    func logout() {
        KeychainWrapper.standard.remove(forKey: "accessToken")
        KeychainWrapper.standard.remove(forKey: "refreshToken")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }

    func getAccessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "accessToken")
    }

    private func saveTokens(access: String, refresh: String) {
        KeychainWrapper.standard.set(access, forKey: "accessToken")
        KeychainWrapper.standard.set(refresh, forKey: "refreshToken")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    //alyssa's reset password
    func requestPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "https://tastebuds.unr.dev/accounts/password/reset/") else {
                completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = ["email": email]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    completion(.success(()))
                } else {
                    let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown error"
                    completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            }.resume()
        }
        //alyssa's function
        func changePassword(oldPassword: String, newPassword: String, confirmNewPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "https://tastebuds.unr.dev/api/change-password/") else{
                completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token available."])))
                return
            }

            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

            let body = [
                "old_password": oldPassword,
                "new_password": newPassword,
                "confirm_password": confirmNewPassword
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    completion(.success(()))
                } else {
                    let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown error"
                    completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            }.resume()
        }
    func getCSRFToken() -> String? {
            let cookieStorage = HTTPCookieStorage.shared
            for cookie in cookieStorage.cookies ?? [] {
                if cookie.name == "csrftoken" {
                    return cookie.value
                }
            }
            return nil
        }
    func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                try await self.refreshToken()
                completion(true)
            } catch {
                print("Token refresh failed: \(error)")
                completion(false)
            }
        }
    }
    private func sendRequest(url: URL, body: [String: Any]) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResp = response as? HTTPURLResponse else {
            throw AuthError.serverError("No HTTP response.")
        }

        switch httpResp.statusCode {
        case 200..<300:
            return data
        case 400:
            throw AuthError.decoding(data)
        case 401:
            throw AuthError.invalidCredentials
        case 403:
            throw AuthError.tooManyAttempts
        case 409:
            throw AuthError.userAlreadyExists
        default:
            let msg = String(data: data, encoding: .utf8) ?? "Unknown server error"
            throw AuthError.serverError(msg)
        }


    }
}
