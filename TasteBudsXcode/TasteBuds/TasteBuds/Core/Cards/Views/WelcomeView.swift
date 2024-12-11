import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.66, green: 0.31, blue: 0.33)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack {
                        Image("white_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 380, height: 270)
                            .offset(y: 35)
                            .padding(.top, 0)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image("leftcharacter")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 358, height: 434)
                            .rotationEffect(.degrees(-3.1))
                            .clipped()
                        
                        Spacer()
                        
                        
                        
                        Image("rightcharacter")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 225, height: 298)
                            .rotationEffect(.degrees(8.57))
                            .clipped()
                            .offset(x: -35)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    
                    
                    NavigationLink(destination: LoginSignupView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width: 314, height: 70)
                            Text("Get started")
                                .font(Font.custom("Abyssinica SIL", size: 26))
                                .foregroundColor(.black.opacity(0.8))
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
