import SwiftUI

struct PartnerSetupView: View {
    @EnvironmentObject var navigationState: NavigationState

    @AppStorage("isNewUser") private var isNewUser = false
    @State private var partnerE: String = ""
    @State private var showAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToDietaryPreferences = false

    var isNewUserPassed: Bool

    var body: some View {
        ZStack {
            Color.clear.customGradientBackground()

            VStack(spacing: 30) {
                if isNewUser {
                    HStack {
                        Spacer()
                        VStack {
                            Button("Skip") {
                                navigateToDietaryPreferences = true
                            }
                            .foregroundColor(.gray)
                            .frame(width: 120, height: 37)
                            .padding()
                            .offset(y: 50)

                            NavigationLink(
                                destination: DietaryPreferencesView()
                                    .environmentObject(navigationState),
                                isActive: $navigateToDietaryPreferences
                            ) {
                                EmptyView()
                            }
                            .hidden()
                        }
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
                    TextField("Partner's Email", text: $partnerE)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .font(.custom("Abyssinica SIL", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 30)

                Button(action: {
                    isLoading = true
                    let normalizedEmail = partnerE.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    PartnerService.shared.sendPartnerRequest(email: normalizedEmail) { result in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch result {
                            case .success:
                                showAlert = true
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                                showErrorAlert = true
                            }
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .frame(width: 314, height: 70)
                            .background(Color.white)
                            .cornerRadius(30)
                    } else {
                        Text("Add Partner")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                            .frame(width: 314, height: 70)
                            .background(Color.white)
                            .cornerRadius(30)
                    }
                }
                .disabled(isLoading || partnerE.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding(.bottom, 50)
                .offset(y: 50)

                Spacer()
            }
            .frame(width: 414, height: 896)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Request Sent"),
                message: Text("Your partner request has been sent successfully."),
                dismissButton: .default(Text("OK")) {
                    navigateToDietaryPreferences = true
                }
            )
        }
        .alert("Oops!", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    PartnerSetupView(isNewUserPassed: true)
        .environmentObject(NavigationState())
}
