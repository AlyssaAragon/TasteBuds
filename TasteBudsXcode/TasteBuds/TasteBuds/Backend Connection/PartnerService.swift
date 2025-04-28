import Foundation

class PartnerService {
    static let shared = PartnerService()
    private init() {}
    
    // MARK: - 1. Send Partner Request
    func sendPartnerRequest(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        makeAuthedRequest(
            endpoint: "/api/link-partner/",
            method: "POST",
            body: ["partner_email": email]
        ) { result in
            switch result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                // Try to parse server error response
                if let nsError = error as NSError?,
                   let errorString = nsError.userInfo[NSLocalizedDescriptionKey] as? String {
                    if errorString.contains("account does not exist") {
                        completion(.failure(PartnerError.accountNotFound))
                        return
                    } else if errorString.contains("already linked") {
                        completion(.failure(PartnerError.alreadyHasPartner))
                        return
                    } else if errorString.contains("Invalid") {
                        completion(.failure(PartnerError.invalidRequest))
                        return
                    }
                }
                completion(.failure(PartnerError.unknown))
            }
        }
    }


    // MARK: - 2. Get Incoming Requests
    func getPendingPartnerRequests(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        makeAuthedRequest(
            endpoint: "/api/partner-requests/",
            method: "GET",
            body: nil
        ) { result in
            switch result {
            case .success(let jsonString):
                if let data = jsonString.data(using: .utf8),
                   let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    completion(.success(jsonArray))
                }
                else {
                    completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - 3. Respond to Partner Request (accept or decline)
    func respondToRequest(requestId: Int, action: String, completion: @escaping (Result<String, Error>) -> Void) {
        makeAuthedRequest(
            endpoint: "/api/respond-partner-request/",
            method: "POST",
            body: [
                "request_id": requestId,
                "action": action
            ],
            completion: completion
        )
    }

    // MARK: - Core Authed Request Handler
    private func makeAuthedRequest(
        endpoint: String,
        method: String,
        body: [String: Any]?,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let token = AuthService.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token found."])))
            return
        }

        guard let url = URL(string: "https://tastebuds.unr.dev\(endpoint)") else {
            completion(.failure(NSError(domain: "URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
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

            guard (200...299).contains(httpResponse.statusCode) else {
                // ❗ If not 200-299, treat it as an error immediately
                completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"])))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }

            if let str = String(data: data, encoding: .utf8) {
                completion(.success(str))
            } else {
                completion(.failure(NSError(domain: "StringParse", code: 0, userInfo: nil)))
            }
        }.resume()
    }

}
extension PartnerService {
    enum PartnerError: Error {
        case accountNotFound
        case alreadyHasPartner
        case invalidRequest
        case unknown
    }
}
