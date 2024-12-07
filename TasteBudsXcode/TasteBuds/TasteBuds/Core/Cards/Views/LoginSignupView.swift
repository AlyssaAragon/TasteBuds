import SwiftUI

struct LoginSignupView: View {
    @State private var isLogin = true
    @State private var profileName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    @StateObject private var viewModel = CardsViewModel(recipeFetcher: RecipeFetcher())

    var body: some View {
        ZStack {
            Color(red: 0.66, green: 0.31, blue: 0.33)
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
                        Image("chefhat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.bottom, 20)
                            .offset(y: -30)

                        HStack {
                            Button(action: {
                                isLogin = true
                            }) {
                                Text("Login")
                                    .font(Font.custom("Abyssinica SIL", size: 25))
                                    .foregroundColor(isLogin ? .black : .gray)
                                    .padding(.top, 10)
                            }

                            Spacer()

                            Button(action: {
                                isLogin = false
                            }) {
                                Text("Sign-up")
                                    .font(Font.custom("Abyssinica SIL", size: 25))
                                    .foregroundColor(!isLogin ? .black : .gray)
                                    .padding(.top, 10)
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
                                .foregroundColor(.white)
                            TextField("Enter profile name here", text: $profileName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .font(Font.custom("Abyssinica SIL", size: 20))
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email Address")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .foregroundColor(.white)
                            TextField("Enter email address here", text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .font(Font.custom("Abyssinica SIL", size: 20))
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Username")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.white)
                        TextField("Enter username here", text: $username)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.white)
                            .font(Font.custom("Abyssinica SIL", size: 20))
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(.white)
                    }
                    .padding(.top, isLogin ? 10 : 30)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Password")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.white)
                        SecureField("Enter password here", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.white)
                            .font(Font.custom("Abyssinica SIL", size: 20))
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)

                    if isLogin {
                        HStack {
                            Spacer()
                            Text("Forgot password?")
                                .font(Font.custom("Abyssinica SIL", size: 16))
                                .foregroundColor(.white)
                                .padding(.top, 5)
                        }
                    }
                }
                .padding(30)
                .offset(y: -50)

                NavigationLink(destination: isLogin ? AnyView(CardView(viewModel: viewModel, model: viewModel.cardModels.first!)) : AnyView(AddPartnerView())) {
                    Text(isLogin ? "Login" : "Sign-up")
                        .font(Font.custom("Abyssinica SIL", size: 26))
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
            }
            .frame(width: 414, height: 896)
        }
    }
}
