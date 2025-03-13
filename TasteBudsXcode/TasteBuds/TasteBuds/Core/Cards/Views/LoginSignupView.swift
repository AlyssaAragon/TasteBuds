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
                    
                    //MARK: - upper half
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 414, height: 382)
                        .background(Color.white.opacity(0.25))
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 4)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.white, lineWidth: 0)
//                        )
                        .offset(y: -100)
                    
                    VStack {
                        Image("white_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .padding()
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
                
                //MARK: - lower half
                VStack(spacing: 15) {
                    if isLogin {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.black)
                            TextField("Enter email", text: $emailOrUsername)
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
                .offset(y: -55)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.bottom, 30) // Move error message up
                }
                
                Button(action: { handleAuth() }) {
                    Text(isLogin ? "Login" : "Sign-up")
                        .font(.system(size: 26))
                        .foregroundColor(.black)
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                        //.offset(y: isLogin ? 65 : -20)
                }
                .padding(.bottom, 70)
                
            }
            .frame(width: 414, height: 896)
        }
    }
    //MARK: - authentication
    private func handleAuth() {
        if isLogin {
            if emailOrUsername.isEmpty || password.isEmpty {
                showErrorMessage("Please fill in all fields.")
                return
            }
            AuthService.shared.login(email: emailOrUsername, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.isLoggedIn = true
                        self.navigationState.nextView = .cardView
                    case .failure:
                        self.showErrorMessage("Invalid username or password.")
                    }
                }
            }
        } else {
            if email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                showErrorMessage("All fields are required.")
                return
            }
            if password != confirmPassword {
                showErrorMessage("Passwords do not match.")
                return
            }
            AuthService.shared.signup(email: email, username: username, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.isLogin = true
                        self.emailOrUsername = self.email
                        self.handleAuth()
    case .failure(let error):
        if error.localizedDescription.contains("users_username_key") {
            showErrorMessage("Username is already taken.")
        } else if error.localizedDescription.contains("users_email_key") {
            showErrorMessage("Email is already registered.")
        } else {
            showErrorMessage("Signup failed. Please try again.")
        }
    }
}
}
}
}
    //MARK: - error message
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView(navigationState: NavigationState())
    }
}
