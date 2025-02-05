import SwiftUI

struct LoginSignupView: View {
    @State private var isLogin = true
    @State private var profileName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false
    
    // Add navigationState as a parameter
    @ObservedObject var navigationState: NavigationState
    
    // Control which view should show up
    // When user creates an account, it's skipping past the set partner and set diet preferences
    @State private var isWaitingForNextView = false
    
    var body: some View {
        ZStack {
            Color(red: 173.0/255.0, green: 233.0/255.0, blue: 251.0/255.0)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 414, height: 382)
                        .background(.white)
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.06), radius: 15, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white, lineWidth: 1)
                        )
                        .offset(y: -100)

                    VStack {
                        Image("tasteBudMascot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.bottom, 20)
                            .offset(y: -30)

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
                    if !isLogin {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Profile Name")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.black)
                            TextField("Enter profile name here", text: $profileName)
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(.black)
                        }
                        .offset(y: -70)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email Address")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.black)
                            TextField("Enter email address here", text: $email)
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(.black)
                        }
                        .offset(y: -60)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Username")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.black)
                        TextField("Enter username here", text: $username)
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(.black)
                    }
                    .offset(y: isLogin ? -70 : -50)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Password")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.black)
                        SecureField("Enter password here", text: $password)
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(.black)
                    }
                    .offset(y: -50)
                }
                .padding(30)
                .offset(y: -50)

                Button(action: {
                    if isLogin {
                        isLoggedIn = true
                        navigationState.nextView = .cardView // Navigate to card view on login
                    } else {
                        isNewUser = true
                        navigationState.nextView = .addPartner // Navigate to add partner on sign-up
                        isWaitingForNextView = true // Add waiting state
                    }
                }) {
                    Text(isLogin ? "Login" : "Sign-up")
                        .font(Font.custom("Abyssinica SIL", size: 26))
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                .padding(.bottom, 50)
            }
            .frame(width: 414, height: 896)
            .onChange(of: navigationState.nextView) { newView in
                if isWaitingForNextView && newView == .addPartner {
                    // Give the user a chance to see the AddPartnerView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        navigationState.nextView = .dietaryPreferences // After 1 second, move to dietary preferences
                    }
                }
                if newView == .dietaryPreferences {
                    // After user completes dietary preferences, navigate to card view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        navigationState.nextView = .cardView
                    }
                }
            }
        }
    }
}

#Preview {
    LoginSignupView(navigationState: NavigationState())
}
