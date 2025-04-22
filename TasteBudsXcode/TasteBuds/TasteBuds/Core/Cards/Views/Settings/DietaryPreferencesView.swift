import SwiftUI

struct DietaryPreferencesView: View {
    @State private var showAlert: Bool = false
    @State private var isFirstUse: Bool = UserDefaults.standard.bool(forKey: "isFirstUse")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear.customGradientBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        if isFirstUse {
                            HStack {
                                Spacer()
                                NavigationLink(destination: CardView()) {
                                    Text("Skip")
                                        .font(Font.custom("Abyssinica SIL", size: 20))
                                        .foregroundColor(.black)
                                        .frame(width: 120, height: 37)
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
                            .padding(.top, 20)
                        
                        Text("You can set your dietary preferences here. These will affect your recipe recommendations.")
                            .font(.body)
                            .italic()
                            .foregroundColor(.black)
                            .frame(width: geometry.size.width * 0.9, alignment: .leading)
                        
                        sectionLabel(title: "Allergies", width: geometry.size.width * 0.9)
                        
                        Button(action: {
                            // Add allergy functionality
                        }) {
                            Text("+ Add Allergens")
                                .font(Font.custom("Inter", size: 24))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 30)
                        
                        sectionLabel(title: "Diets", width: geometry.size.width * 0.9)
                        
                        Button(action: {
                            // Add diet action
                        }) {
                            Text("+ Add Diets")
                                .font(Font.custom("Inter", size: 24))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer(minLength: 40)
                        
                        Button(action: {
                            sendInvitation()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width * 0.8, height: 70)
                                
                                Text("Save Preferences")
                                    .font(Font.custom("Abyssinica SIL", size: 26))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.bottom, 60)
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding(.top, 10)
                }
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
    }
    
    private func sectionLabel(title: String, width: CGFloat) -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: width, height: 68)
            .background(.white.opacity(0.5))
            .overlay(
                Text(title)
                    .font(Font.custom("Abyssinica SIL", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: width, height: 63)
            )
    }
    
    private func sendInvitation() {
        showAlert = true
    }
}

#Preview {
    DietaryPreferencesView()
}
