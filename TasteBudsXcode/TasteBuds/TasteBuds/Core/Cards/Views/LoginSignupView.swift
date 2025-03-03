import SwiftUI

struct LoginSignupView: View {
    @State private var isLogin = true
    @State private var emailOrUsername = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false
    
    @ObservedObject var navigationState: NavigationState
    @State private var isWaitingForNextView = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.clear.customGradientBackground()
                    VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 414, height: 382)
                        .background(.white.opacity(0.25))
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.06), radius: 15, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white, lineWidth: 0)
                        )
                        .offset(y: -100)
                    
                    VStack {
                        Image("white_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .padding(.bottom, 20)
                            .shadow(radius: 50)
                            .offset(y: -70)
                        
                        HStack {
                            Button(action: { isLogin = true }) {
                                Text("Login")
                                    .font(Font.custom("Abyssinica SIL", size: 25))
                                    .foregroundColor(isLogin ? .black : .gray)
                                    .offset(y: -15)
                            }
                            
                            Spacer()
                            
                            Button(action: { isLogin = false }) {
                                Text("Sign-up")
                                    .font(Font.custom("Abyssinica SIL", size: 25))
                                    .foregroundColor(!isLogin ? .black : .gray)
                                    .offset(y: -15)
                            }
                        }
                        .padding(.horizontal, 50)
                    }
                }
                .padding(.bottom, 30)
                
                VStack(spacing: 15) {
                    if isLogin {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email or Username")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.black)
                            TextField("Enter email or username", text: $emailOrUsername)
                            Rectangle().frame(height: 0.5).foregroundColor(.black)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email Address")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.black)
                            TextField("Enter email address", text: $email)
                            Rectangle().frame(height: 0.5).foregroundColor(.black)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Username")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.black)
                            TextField("Enter username", text: $username)
                            Rectangle().frame(height: 0.5).foregroundColor(.black)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Password")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.black)
                        SecureField("Enter password", text: $password)
                        Rectangle().frame(height: 0.5).foregroundColor(.black)
                    }
                    
                    if !isLogin {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Confirm Password")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.black)
                            SecureField("Re-enter password", text: $confirmPassword)
                            Rectangle().frame(height: 0.5).foregroundColor(.black)
                        }
                    }
                }
                .padding(30)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.top, 5)
                }
                
                Button(action: {
                    handleAuth()
                }) {
                    Text(isLogin ? "Login" : "Sign-up")
                        .font(Font.custom("Abyssinica SIL", size: 26))
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .shadow(radius: 75)
                        .cornerRadius(30)
                }
                .padding(.bottom, 50)
            }
            .frame(width: 414, height: 896)
        }
    }
//the server is not properly fetching the csrf token so im going to make it csrf exempt for now. but hoping to get it working after demo
    private func handleAuth() {
        let action = isLogin ? "login" : "signup"
        CSRFHandler.checkCSRFToken(for: action) { token in
            guard let csrfToken = token else {
                DispatchQueue.main.async { self.showErrorMessage("Failed to fetch CSRF token.") }
                return
            }
            
            let url = URL(string: "https://tastebuds.unr.dev/accounts/\(action)/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-Token")
            if let cookies = HTTPCookieStorage.shared.cookies(for: url), let csrfCookie = cookies.first(where: { $0.name == "csrftoken" }) {
                request.setValue("\(csrfCookie.name)=\(csrfCookie.value)", forHTTPHeaderField: "Cookie")
            }
            let body: [String: String] = isLogin ?
                ["emailOrUsername": emailOrUsername, "password": password] :
                ["email": email, "username": username, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showErrorMessage("Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        if isLogin {
                            self.isLoggedIn = true
                            self.navigationState.nextView = .cardView
                        } else {
                            self.isNewUser = true
                            self.navigationState.nextView = .addPartner
                        }
                    }
                } else {
                    DispatchQueue.main.async { self.showErrorMessage("Error.") }
                }
            }.resume()
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}

#Preview {
    LoginSignupView(navigationState: NavigationState())
}
