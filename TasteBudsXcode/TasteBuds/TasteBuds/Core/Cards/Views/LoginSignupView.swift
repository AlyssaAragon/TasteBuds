import SwiftUI

struct LoginSignupView: View {
    @State private var isLogin = true
    @State private var fullName = ""
    @State private var emailOrUsername = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false
    @State private var resetEmail = ""
    @State private var showPasswordResetSheet = false
    @ObservedObject var navigationState: NavigationState
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear.customGradientBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.44)
                                .background(Color.white.opacity(0.25))
                                .cornerRadius(30)
                                .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 4)
                                .offset(y: -geometry.size.height * 0.12)
                            
                            VStack {
                                Image("white_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.7)
                                    .padding()
                                    .padding(.bottom, 15)
                                    .shadow(radius: 50)
                                    .offset(y: -geometry.size.height * 0.05)
                                
                                HStack {
                                    Button(action: { isLogin = true }) {
                                        Text("Login")
                                            .font(Font.custom("Abyssinica SIL", size: 25))
                                            .foregroundColor(isLogin ? .black : .gray)
                                            .offset(y: -10)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: { isLogin = false }) {
                                        Text("Sign-up")
                                            .font(Font.custom("Abyssinica SIL", size: 25))
                                            .foregroundColor(!isLogin ? .black : .gray)
                                            .offset(y: -10)
                                    }
                                }
                                .padding(.horizontal, geometry.size.width * 0.15)
                            }
                        }
                        
                        VStack(spacing: 15) {
                            if isLogin {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Email")
                                        .font(Font.custom("Abyssinica SIL", size: 20))
                                        .foregroundColor(.black)
                                    TextField("Enter email", text: $emailOrUsername)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                    Rectangle().frame(height: 0.5).foregroundColor(.black)
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Full Name")
                                        .font(Font.custom("Abyssinica SIL", size: 20))
                                        .foregroundColor(.black)
                                    TextField("Enter full name", text: $fullName)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                    Rectangle().frame(height: 0.5).foregroundColor(.black)
                                }

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Email Address")
                                        .font(Font.custom("Abyssinica SIL", size: 20))
                                        .foregroundColor(.black)
                                    TextField("Enter email address", text: $email)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                    Rectangle().frame(height: 0.5).foregroundColor(.black)
                                }

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Username")
                                        .font(Font.custom("Abyssinica SIL", size: 20))
                                        .foregroundColor(.black)
                                    TextField("Enter username", text: $username)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                    Rectangle().frame(height: 0.5).foregroundColor(.black)
                                }
                            }

                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Password")
                                    .font(Font.custom("Abyssinica SIL", size: 20))
                                    .foregroundColor(.black)
                                SecureField("Enter password", text: $password)
                                    .textContentType(.none)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                Rectangle().frame(height: 0.5).foregroundColor(.black)
                            }
                            
                            if !isLogin {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Confirm Password")
                                        .font(Font.custom("Abyssinica SIL", size: 20))
                                        .foregroundColor(.black)
                                    SecureField("Re-enter password", text: $confirmPassword)
                                        .textContentType(.none)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                    Rectangle().frame(height: 0.5).foregroundColor(.black)
                                }
                            }
                        }
                        .padding(30)
                        .offset(y: -20)
                        
                        if showError {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(errorMessages, id: \.self) { msg in
                                HStack(alignment: .top, spacing: 4) {
                                    Text("•").bold()
                                    Text(msg + ".")
                                }
                                .foregroundColor(.red)
                                .font(.system(size: 16, weight: .medium))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                        
                        Button(action: {
                            Task { await handleAuth() }
                        }) {
                        Text(isLogin ? "Login" : "Sign-up")
                                .font(.system(size: 26))
                                .foregroundColor(.black)
                                .frame(width: geometry.size.width * 0.75, height: 70)
                                .background(Color.white)
                                .cornerRadius(30)
                                .shadow(radius: 10)
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        /* commenting out 'forgot password' functionality until we integrate an email service provider like Google Workspace to send reset emails
        .sheet(isPresented: $showPasswordResetSheet) {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.title2)
                    .bold()
                
                TextField("Enter your email", text: $resetEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                HStack {
                    Button("Cancel") {
                        showPasswordResetSheet = false
                        resetEmail = ""
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("Send") {
                        showPasswordResetSheet = false
                        requestPasswordReset()
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            .padding()*/
        }
    private func field(title: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(Font.custom("Abyssinica SIL", size: 20))
                .foregroundColor(.black)
            if isSecure {
                SecureField("Enter \(title.lowercased())", text: text)
                    .textContentType(.none)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField("Enter \(title.lowercased())", text: text)
            }
            Rectangle().frame(height: 0.5).foregroundColor(.black)
        }
    }

    private var errorMessages: [String] {
        return errorMessage
            .components(separatedBy: [".", ","])
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }

    private func decodeBackendErrorData(_ data: Data) -> String? {
        // Try strict decoding first
        if let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) {
            let messages = decoded.flatMap { $0.value }.joined(separator: ". ")
            return messages + "."
        }

        // Fallback: decode [String: String] and convert to [String: [String]]
        if let fallback = try? JSONDecoder().decode([String: String].self, from: data) {
            let converted = fallback.mapValues { [$0] }  // wrap values in array
            let messages = converted.flatMap { $0.value }.joined(separator: ". ")
            return messages + "."
        }

        print("Final decode failure. Raw data:", String(data: data, encoding: .utf8) ?? "n/a")
        return nil
    }


    //MARK: - authentication
    private func handleAuth() async{
        if isLogin {
            guard !emailOrUsername.isEmpty, !password.isEmpty else {
                showErrorMessage("Please fill in all fields.")
                return
            }

            do {
                try await AuthService.shared.login(email: emailOrUsername, password: password)
                self.isLoggedIn = true
                self.navigationState.nextView = .cardView
            } catch let error as AuthError {
                switch error {
                case .invalidCredentials:
                    self.showErrorMessage("Invalid email or password.")
                case .tooManyAttempts:
                    self.showErrorMessage("Too many login attempts. Please wait and try again.")
                case .decoding(let data):
                    if let msg = decodeBackendErrorData(data) {
                        self.showErrorMessage(msg)
                    } else {
                        self.showErrorMessage("Login failed. Please try again.")
                    }
                default:
                    self.showErrorMessage("Login failed. Please try again.")
                }
            } catch {
                self.showErrorMessage("Unexpected login error.")
            }
        } else {
            guard !fullName.isEmpty,
                  !email.isEmpty,
                  !username.isEmpty,
                  !password.isEmpty,
                  !confirmPassword.isEmpty else {
                showErrorMessage("All fields are required.")
                return
            }

            guard password == confirmPassword else {
                showErrorMessage("Passwords do not match.")
                return
            }

            do {
                try await AuthService.shared.signup(
                    email: email,
                    username: username,
                    password: password,
                    fullName: fullName,
                    confirmPassword: confirmPassword
                )
                print("Signup succeeded")

                try await AuthService.shared.login(email: email, password: password)
                print("Login succeeded")

                if let access = AuthService.shared.getAccessToken() {
                    print("Access token saved:", access.prefix(30)) // Print token for debugging
                } else {
                    print("No access token saved after login!")
                }

                self.isLoggedIn = true
                self.isNewUser = true
                self.navigationState.nextView = .addPartner

            }
 catch let error as AuthError {
                switch error {
                case .userAlreadyExists:
                    self.showErrorMessage("User already exists.")
                case .serverError(let msg):
                    self.showErrorMessage(msg)
                case .decoding(let data):
                    if let msg = decodeBackendErrorData(data) {
                        self.showErrorMessage(msg)
                    } else {
                        self.showErrorMessage("Signup failed. Please try again.")
                    }
                default:
                    self.showErrorMessage("Signup failed. Please try again.")
                }
            } catch {
                self.showErrorMessage("Unexpected signup error.")
            }
        }
    }

}
/* commenting out 'forgot password' functionality until we integrate an email service provider like Google Workspace to send reset emails
    private func requestPasswordReset() {
        AuthService.shared.requestPasswordReset(email: resetEmail) { result in
            switch result {
            case .success:
                showErrorMessage("Password reset email sent.")
            case .failure(let error):
                showErrorMessage("Error sending password reset email: \(error.localizedDescription)")
            }
        }
    }*/
    
struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView(navigationState: NavigationState())
    }
}
