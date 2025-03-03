//  AuthService.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 3/2/25.
//

import Foundation
// tokens needed for loggin in and signing up
struct AuthResponse: Codable {
    let access: String
    let refresh: String
}

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    // Login function using your JWT token endpoint.
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        guard let url = URL(string: "https://tastebuds.unr.dev/api/token/") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginBody = [
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    
                    //Store the token in UserDefaults
                    UserDefaults.standard.set(authResponse.access, forKey: "accessToken")
                    UserDefaults.standard.set(authResponse.refresh, forKey: "refreshToken")
                    UserDefaults.standard.synchronize() // Ensure immediate save
                    
                    print("Access token stored: \(authResponse.access)") // Debugging
                    
                    completion(.success(authResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }.resume()
    }

    
    func signup(email: String, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://tastebuds.unr.dev/api/signup/") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let signupBody = [
            "email": email,
            "username": username,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: signupBody, options: [])
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
            
            if httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown error"
                completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }.resume()
    }
    
    // Logout function that clears stored tokens
    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
    
    private func errorMessage(for error: Error) -> String {
        let nsError = error as NSError
        if nsError.domain == "HTTPError" {
            if let errorMessage = nsError.userInfo[NSLocalizedDescriptionKey] as? String {
                if errorMessage.contains("duplicate") {
                    return "That email or username is already in use."
                }
                return errorMessage
            }
        }
        return error.localizedDescription
    }
}
