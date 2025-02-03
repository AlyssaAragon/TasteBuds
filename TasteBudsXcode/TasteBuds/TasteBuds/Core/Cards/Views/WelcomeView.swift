import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    
    var body: some View {
        ZStack {
            Color(red: 246.0/255.0, green: 227.0/255.0, blue: 143.0/255.0)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("white_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380, height: 270)
                    .offset(y: 35)
                
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
                            .frame(width: 314, height: 70)
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
