import SwiftUI

struct PartnerSetupView: View {
    @State private var partnerE: String = ""
    @State private var showAlert: Bool = false
    @State private var isFirstUse: Bool = UserDefaults.standard.bool(forKey: "isFirstUse")
    
    var isNewUser: Bool
    
    var body: some View {
        ZStack {
            Color.clear.customGradientBackground()
            
            VStack(spacing: 30) {
                // Only show the "Skip" button if it's the first use
                if isFirstUse {
                    HStack {
                        Spacer()
                        Button(action: {
                        }) {
                            Text("Skip")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 120, height: 37)
                        .padding()
                        .offset(y: 50)
                    }
                }
                
                Image("connectPartner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .padding(.top, 60)
                
                Text("Add your TasteBud")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 20) {
                    TextField("Partner's Email", text: $partnerE)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .font(.custom("Abyssinica SIL", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 30)
                
                Button(action: {sendInvitation(partnerEmail: partnerE) { success, message in
                    if success {
                        // Handling success, show the alert
                        self.showAlert = true

                    } else {
                        // Handling failure, show the error message
                        print("Error: \(message)")
                    }
                }
                }) {
                    Text("Add Partner")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                .padding(.bottom, 50)
                .offset(y: 50)
                
                if isNewUser {
                    NavigationLink(destination: DietaryPreferencesView()) {
                    }
                }
                
                Spacer()
            }
            .frame(width: 414, height: 896)
        }
        .onAppear {
            if isFirstUse {
                UserDefaults.standard.set(false, forKey: "isFirstUse")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Partner added"),
                  message: Text("You have successfully added your partner!"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func sendInvitation(partnerEmail: String, completion: @escaping (Bool, String) -> Void) {
    
        guard let url = URL(string: "https://tastebuds.unr.dev/api/link-partner/") else {
            completion(false, "Invalid URL")
            return
        }
        
        let requestBody: [String: Any] = ["partner_email": partnerEmail]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            completion(false, "Error creating JSON data")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "accessToken") {  print("Token found: \(token)")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }else {
            print("No token found")
        }
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")


        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle the error
                DispatchQueue.main.async {
                    completion(false, "Request failed: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, "No data received")
                }
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(responseString)")
            }

            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = responseJSON["message"] as? String {
                        DispatchQueue.main.async {
                            completion(true, message)
                        }
                    } else if let error = responseJSON["error"] as? String {
                        DispatchQueue.main.async {
                            completion(false, error)
                        }
                    } else {
                        // Unexpected response format
                        DispatchQueue.main.async {
                            completion(false, "Unexpected response format: \(responseJSON)")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, "Error parsing response as JSON: \(data)")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, "Error parsing response: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}

#Preview {
    PartnerSetupView(isNewUser: true)
}
