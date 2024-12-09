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
                                    .offset(y: -15)
                            }
                            
                            Spacer()

                            Button(action: {
                                isLogin = false
                            }) {
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

                VStack(spacing: 15){
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
                        .offset(y: -70)
                        
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
                        .offset(y: -60)
                    }

                    VStack(alignment: .leading, spacing: 5){
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
                    .offset(y: isLogin ? -70 : -50)

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
                    .offset(y: -50)
                    .onAppear{
                        if isLogin {
                            //HStack {
                            Task{
                                await viewModel.fetchRecipe()
                            }
                               // Spacer()
                               // Text("Forgot password?")
                                   // .font(Font.custom("Abyssinica SIL", size: 16))
                                //    .foregroundColor(.white)
                                //    .padding(.top, 5)
                                 //   .offset(y: -50)
                                 //   .offset(x: -225)
                          //  }
                        }
                    }
                }
                .padding(30)
                .offset(y: -50)
<<<<<<< HEAD
                NavigationLink(destination: {
                                    if isLogin {
                                        // If login, navigate to CardView which fetches its own recipe
                                        return AnyView(CardView()) // Directly using CardView here
                                    } else {
                                        // If signing up, navigate to AddPartnerView
                                        return AnyView(AddPartnerView())
                                    }
                                }()) {
                                    Text(isLogin ? "Login" : "Sign-up")
                                        .font(Font.custom("Abyssinica SIL", size: 26))
                                        .foregroundColor(.black.opacity(0.8))
                                        .frame(width: 314, height: 70)
                                        .background(Color.white)
                                        .cornerRadius(30)
                                        .shadow(radius: 10)
                                }
                                .padding(.bottom, 50)
=======
                NavigationLink(destination: { //needs to be changed to reflect changes in cardview
                    if isLogin {
                        //If the user is logging in, navigate to the CardView with the fetched recipe
                        if let fetchedRecipe = viewModel.currentRecipe {
                            return AnyView(CardView( viewModel: viewModel))
                        } else {
                            return AnyView(Text("No recipes available"))
                        }
                    } else {
                        //If the user is signing up, navigate to AddPartnerView
                        return AnyView(AddPartnerView())
                    }
                }()) {
                    Text(isLogin ? "Login" : "Sign-up")
                        .font(Font.custom("Abyssinica SIL", size: 26))
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 50)
>>>>>>> 02e6dd86ac2df738a350ede54be517f22ba56d7c


            }
            .frame(width: 414, height: 896)
        }
    }
}

#Preview {
    LoginSignupView()
}
