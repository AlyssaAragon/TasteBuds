/*
 //
//  UserAuthService.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 2/26/25.
//
import Foundation
class UserAuthService {
    static let shared = UserAuthService()
    
    let baseURL = "https://tastebuds.unr.dev/accounts"

    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let url = URL(string: "\(baseURL)/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, "Network error")
                return
            }
            let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let success = responseDict?["success"] as? Bool ?? false
            let message = responseDict?["message"] as? String ?? "Unknown error"

            DispatchQueue.main.async {
                completion(success, message)
            }
        }.resume()
    }

    func signup(email: String, username: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let url = URL(string: "\(baseURL)/signup/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, "Network error")
                return
            }
            let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let success = responseDict?["success"] as? Bool ?? false
            let message = responseDict?["message"] as? String ?? "Unknown error"

            DispatchQueue.main.async {
                completion(success, message)
            }
        }.resume()
    }
}
*/
