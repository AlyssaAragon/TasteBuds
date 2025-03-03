import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        ZStack {
            Color.clear.customGradientBackground()
            
            VStack {
                Image("white_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380, height: 270)
                    .shadow(radius: 65)
                
                Image("kitchenWelcome")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: Color(hex: 0xfbe13f), radius: 100)
                
                Spacer()
                
                Button(action: {
                    // Navigate to the login/signup screen
                    navigationState.nextView = .loginSignup
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .opacity(0.7)
                            .frame(width: 314, height: 70)
                            .shadow(radius: 75)
                        Text("Get started")
                            .font(Font.custom("Abyssinica SIL", size: 26))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(NavigationState())
}

