//
//  CSRFHandler.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 3/2/25.
//
import Foundation

class CSRFHandler {
    static func checkCSRFToken(for action: String, completion: @escaping (String?) -> Void) {
        let urlString: String
        if action == "signup" {
            urlString = "https://tastebuds.unr.dev/accounts/signup/"
        } else {
            urlString = "https://tastebuds.unr.dev/accounts/login/"
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("text/html", forHTTPHeaderField: "Accept")
        request.addValue("en-US,en;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching CSRF token: \(error)")
                completion(nil)
                return
            }
            
            guard let response = response, let _ = data else {
                completion(nil)
                return
            }
            
            print("Response received: \(response)")
            
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: (response as! HTTPURLResponse).allHeaderFields as! [String: String], for: url)
            
            if let csrfTokenCookie = cookies.first(where: { $0.name == "csrftoken" }) {
                HTTPCookieStorage.shared.setCookies([csrfTokenCookie], for: url, mainDocumentURL: nil)
                print("CSRF Token fetched: \(csrfTokenCookie.value)")
                completion(csrfTokenCookie.value)
            } else {
                print("No CSRF Token found.")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
