import SwiftUI

struct DeleteAccountView: View {
    @State private var showingConfirmation = false
    @State private var showingResultAlert = false
    @State private var alertMessage = ""

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false

    @EnvironmentObject var userFetcher: UserFetcher
    @EnvironmentObject var navigationState: NavigationState

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 60)

            VStack(spacing: 12) {
                Text("Delete Account")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Deleting your account will permanently remove all of your data, including saved recipes, dietary preferences, and partner connection. This action cannot be undone.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Button(action: {
                showingConfirmation = true
            }) {
                Text("Delete My Account")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)

        // Confirmation Alert
        .alert("Are you sure?", isPresented: $showingConfirmation) {
            Button("Delete", role: .destructive) {
                handleDeleteAccount()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }

        // Result Alert
        .alert(isPresented: $showingResultAlert) {
            Alert(
                title: Text(""),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage == "Account deleted successfully." {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            AuthService.shared.logout()
                            isLoggedIn = false
                            isGuestUser = false
                            navigationState.nextView = .welcome
                        }
                    }
                }
            )
        }
    }

    private func handleDeleteAccount() {
        AuthService.shared.deleteAccount { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    alertMessage = "Account deleted successfully."
                case .failure(let error):
                    alertMessage = "Failed to delete account: \(error.localizedDescription)"
                }
                showingResultAlert = true
            }
        }
    }
}
