import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var userFetcher: UserFetcher

    @State private var showingLogoutAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                VStack(spacing: 8) {
                    if let user = userFetcher.currentUser {
                        Text("@\(user.username)")
                            .font(Font.custom("Inter", size: 16).weight(.black))
                            .kerning(0.08)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.14))
                    } else {
                        Text("Loading...")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 200)

                Spacer(minLength: 22)

                VStack(spacing: 0) {
                    NavigationLink(destination: AddPartnerView()
                        .environmentObject(navigationState)) {
                        settingsRow(title: "Partner")
                    }

                    Divider()

                    NavigationLink(destination: DietaryPreferencesView()
                        .environmentObject(navigationState)) {
                        settingsRow(title: "Dietary Preferences")
                    }

                    Divider()

                    NavigationLink(destination: AccessibilityView()
                        .environmentObject(themeManager)) {
                        settingsRow(title: "Accessibility")
                    }

                    Divider()

                    NavigationLink(destination: NotificationPreferencesView()) {
                        settingsRow(title: "Notifications")
                    }

                    Divider()

                    NavigationLink(destination: IngredientSubView()) {
                        settingsRow(title: "Common Ingredient Substitutions")
                    }

                    Divider()

                    settingsRow(title: "Privacy and Security")

                    Divider()

                    Button {
                        showingLogoutAlert = true
                    } label: {
                        settingsRow(title: "Sign Out")
                    }
                    .alert("Sign out of your account?", isPresented: $showingLogoutAlert) {
                        Button("Sign Out", role: .destructive) {
                            handleLogout()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
                .background(Color.white)
                .cornerRadius(8)

                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    if userFetcher.currentUser == nil {
                        await userFetcher.fetchUser()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func settingsRow(title: String) -> some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func handleLogout() {
        AuthService.shared.logout()
        UserDefaults.standard.removeObject(forKey: "accessToken")
        userFetcher.reset()
        isLoggedIn = false
        isNewUser = false
        navigationState.nextView = .welcome
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(NavigationState())
        .environmentObject(UserFetcher())
}
