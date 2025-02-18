import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    
    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: 0xffa65b),
                        Color(hex: 0xffa4c2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(hex: 0xfbe13f, opacity: 0.9), // Transparent white
                        Color.clear // Fully transparent
                    ]),
                    center: .bottomLeading,
                    startRadius: 5,
                    endRadius: 400
                )
                .blendMode(.overlay)
                .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Image("white_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380, height: 270)
                    .shadow(radius: 75)
//                    .offset(y: 35)
                
                Image("kitchenWelcome")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Button(action: {
                    hasSeenWelcome = true
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
}
