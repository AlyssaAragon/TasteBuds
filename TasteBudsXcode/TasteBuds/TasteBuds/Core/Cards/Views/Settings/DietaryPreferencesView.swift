import SwiftUI

struct DietaryPreferencesView: View {
    @State private var showAlert: Bool = false
    @State private var isFirstUse: Bool = UserDefaults.standard.bool(forKey: "isFirstUse")
    
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
                // Only show the "Skip" button if it's the first use
                if isFirstUse {
                    HStack {
                        Spacer()
                        NavigationLink(destination: CardView()) {
                            Text("Skip")
                                .font(Font.custom("Abyssinica SIL", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(width: 120, height: 37, alignment: .top)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }
                
                Text("Dietary Preferences")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Text("You can set your dietary preferences here. These will affect your recipe recommendations.")
                    .font(.body)
                    .italic()
                    .foregroundColor(.black)
                    .frame(width: 340, height: 81, alignment: .topLeading)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 414, height: 68)
                    .background(.white)
                    .opacity(0.5)
                    .overlay(
                        Text("Allergies")
                            .font(Font.custom("Abyssinica SIL", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(width: 414, height: 63)
                    )
                
                Button(action: {
                    // Add allergy functionality
                }) {
                    Text("+ Add Allergens")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .frame(width: 203, height: 26, alignment: .leading)
                }
                .padding(.leading, -120)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 414, height: 68)
                    .background(.white)
                    .opacity(0.5)
                    .overlay(
                        Text("Diets")
                            .font(Font.custom("Abyssinica SIL", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(width: 414, height: 63)
                    )
                
                Button(action: {
                    // Add diet action
                }) {
                    Text("+ Add Diets")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .frame(width: 203, height: 26, alignment: .leading)
                }
                .padding(.leading, -120)
                
                Spacer()
                
                Button(action: {
                    sendInvitation()
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 314, height: 70)
                            .background(.white)
                            .cornerRadius(30)
                        
                        Text("Save Preferences")
                            .font(Font.custom("Abyssinica SIL", size: 26))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.top, -30)
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Preferences added"),
                      message: Text("You have successfully added your preferences!"),
                      dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            if isFirstUse {
                UserDefaults.standard.set(false, forKey: "isFirstUse")
            }
        }
    }
    
    private func sendInvitation() {
        showAlert = true
    }
}

#Preview {
    DietaryPreferencesView()
}
