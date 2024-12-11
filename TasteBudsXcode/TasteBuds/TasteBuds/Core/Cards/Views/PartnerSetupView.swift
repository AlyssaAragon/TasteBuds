import SwiftUI

struct PartnerSetupView: View {
    @State private var partnerUsername: String = ""
    @State private var partnerEmail: String = ""
    @State private var showAlert: Bool = false
    @State private var navigateToDietaryPreferences: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 173.0/255.0, green: 233.0/255.0, blue: 251.0/255.0)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    // Cancel button
                    NavigationLink(destination: AddPartnerView()) {
                        Text("Cancel")
//                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 120, height: 37)
                    .padding(/*.trailing, 20*/)
                    .offset(y: 50)
                }
                
                Image("connectPartner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .padding(.top, 60)
                
                Text("Add your TasteBud")
//                    .font(Font.custom("Abyssinica SIL", size: 27))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
//                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                
                VStack(spacing: 20) {
                    TextField("Partner's Username", text: $partnerUsername)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .font(.custom("Abyssinica SIL", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    sendInvitation()
                }) {
                    Text("Add Partner")
//                        .font(Font.custom("Abyssinica SIL", size: 26))
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
//                        .shadow(radius: 10)
                }
                .padding(.bottom, 30)
                .offset(y: 50)
                
                Spacer()
            }
            .frame(width: 414, height: 896)
            
            // NavigationLink to navigate to DietaryPreferencesView
            NavigationLink(destination: DietaryPreferencesView(), isActive: $navigateToDietaryPreferences) {
                EmptyView()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Partner added"),
                  message: Text("You have successfully added your partner!"),
                  dismissButton: .default(Text("OK"), action: {
                      navigateToDietaryPreferences = true // Trigger navigation after dismiss
                  }))
        }
    }
    
    private func sendInvitation() {
        showAlert = true
    }
}

#Preview {
    PartnerSetupView()
}
