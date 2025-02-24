// Hannah Haggerty
import SwiftUI

struct AddPartnerView: View {
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

            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    NavigationLink(destination: DietaryPreferencesView()){
                        Text("Skip")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 120, height: 37)
                    .padding()
                    .offset(y: 50)
                }
                

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 350, height: 350)
                    .background(
                        Image("connectPartner")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 350)
                            .clipped()
                    )

                Text("Connect with your Taste Bud")
                    .font(.title)
                    .lineLimit(3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            

                
                Text("Invite your cooking partner to share and match recipes, and discover what they’re excited to cook!")
                  .font(Font.custom("Abyssinica SIL", size: 20))
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
                  .padding()

                Spacer()

                NavigationLink(destination: PartnerSetupView(isNewUser: true)){
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                .padding(.bottom, 30)
                .offset(y: -50)
            }
            .frame(width: 414, height: 896)
        }
    }
}

#Preview {
    AddPartnerView()
}
