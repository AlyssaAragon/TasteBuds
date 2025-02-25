import SwiftUI

struct PartnerSetupView: View {
    @State private var partnerUsername: String = ""
    @State private var showAlert: Bool = false
    @State private var isFirstUse: Bool = UserDefaults.standard.bool(forKey: "isFirstUse")
    
    var isNewUser: Bool
    
    var body: some View {
        ZStack {
            Color.clear.customGradientBackground()
            
            VStack(spacing: 30) {
                // Only show the "Skip" button if it's the first use
                if isFirstUse {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle skip action
                        }) {
                            Text("Skip")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 120, height: 37)
                        .padding()
                        .offset(y: 50)
                    }
                }
                
                Image("connectPartner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .padding(.top, 60)
                
                Text("Add your TasteBud")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
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
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                .padding(.bottom, 50)
                .offset(y: 50)
                
                if isNewUser {
                    NavigationLink(destination: DietaryPreferencesView()) {
                    }
                }
                
                Spacer()
            }
            .frame(width: 414, height: 896)
        }
        .onAppear {
            if isFirstUse {
                UserDefaults.standard.set(false, forKey: "isFirstUse")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Partner added"),
                  message: Text("You have successfully added your partner!"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func sendInvitation() {
        showAlert = true
    }
}

#Preview {
    PartnerSetupView(isNewUser: true)
}
