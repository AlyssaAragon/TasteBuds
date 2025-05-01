import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var userFetcher: UserFetcher

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false
    @AppStorage("isGuestUser") private var isGuestUser = false

    @State private var showingLogoutAlert = false
    @State private var showGuestAlert = UserDefaults.standard.bool(forKey: "isGuestUser")


    var body: some View {
        ZStack {
            GeometryReader { geometry in
                NavigationView {
                    ScrollView {
                        VStack(spacing: 0) {
                            Text("Settings")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity)

                            Text("You are using a Beta version of TasteBuds")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)

                            VStack(spacing: 8) {
                                if let user = userFetcher.currentUser {
                                    Text("@\(user.username)")
                                        .font(Font.custom("Inter", size: 16).weight(.black))
                                        .kerning(0.08)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.primary)
                                } else {
                                    Text("Loading...")
                                        .foregroundStyle(.primary)
                                }
                            }
                            .padding(.top, geometry.size.height * 0.1)

                            Spacer(minLength: 22)

                            VStack(spacing: 0) {
                                // Account
                                Section(header: Text("Account")
                                    .fontWeight(.semibold)
                                    .padding(.top, 24)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)) {

                                        NavigationLink(destination: ChangePasswordView()) {
                                            settingsRow(title: "Change Password")
                                        }
                                        Divider()

                                        NavigationLink(destination: PrivacySecurityView()) {
                                            settingsRow(title: "Privacy & Security")
                                        }
                                        Divider()
                                    }

                                // Preferences
                                Section(header: Text("Preferences")
                                    .fontWeight(.semibold)
                                    .padding(.top, 24)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)) {

                                        NavigationLink(destination: AddPartnerView().environmentObject(navigationState)) {
                                            settingsRow(title: "Partner")
                                        }
                                        Divider()

                                        NavigationLink(destination: DietaryPreferencesView().environmentObject(navigationState)) {
                                            settingsRow(title: "Dietary Preferences")
                                        }
                                        Divider()

                                        NavigationLink(destination: AccessibilityView().environmentObject(themeManager)) {
                                            settingsRow(title: "Accessibility")
                                        }
                                        Divider()

                                        NavigationLink(destination: NotificationPreferencesView()) {
                                            settingsRow(title: "Notifications")
                                        }
                                        Divider()
                                    }

                                // Support
                                Section(header: Text("Support")
                                    .fontWeight(.semibold)
                                    .padding(.top, 24)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)) {

                                        NavigationLink(destination: IngredientSubView()) {
                                            settingsRow(title: "Common Ingredient Substitutions")
                                        }
                                        Divider()

                                        NavigationLink(destination: TutorialGalleryView().environmentObject(navigationState)) {
                                            settingsRow(title: "Tutorial")
                                        }
                                        Divider()

                                        Button {
                                            openBugForm()
                                        } label: {
                                            settingsRow(title: "Report a Bug")
                                        }
                                        Divider()
                                    }

                                // Logout
                                Section {
                                    Button {
                                        showingLogoutAlert = true
                                    } label: {
                                        settingsRow(title: "Sign Out")
                                    }
                                    .alert("Sign out of your account?", isPresented: $showingLogoutAlert) {
                                        Button("Sign out", role: .destructive) {
                                            handleLogout()
                                        }
                                        Button("Cancel", role: .cancel) { }
                                    }
                                }
                            }
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 30)

                            Spacer(minLength: 40)
                        }
                        .frame(minHeight: geometry.size.height)
                        .foregroundStyle(.primary)
                        .padding(.bottom, 30)
                    }
                    .background(Color(UIColor.systemBackground))
                    .navigationBarHidden(true)
                    .onAppear {
                        Task {
                            if !AuthService.isGuest && userFetcher.currentUser == nil {
                                await userFetcher.fetchUser()
                            }
                        }
                    }
                }
            }
        }
  
        .alert("You're currently using TasteBuds as a guest.", isPresented: $showGuestAlert) {
            Button("Log in or Sign up", role: .destructive) {
                handleLogout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    navigationState.nextView = .loginSignup
                }
            }
            Button("Continue as Guest", role: .cancel) {
                showGuestAlert = false
            }
        }

    }

    @ViewBuilder
    private func settingsRow(title: String) -> some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.body)
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.accentColor)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func handleLogout() {
        AuthService.shared.logout()
        userFetcher.currentUser = nil
        userFetcher.sessionExpired = false
        isLoggedIn = false
        isNewUser = false
        navigationState.nextView = .welcome
    }

    private func openBugForm() {
        if let url = URL(string: "https://forms.gle/ozaZetH3FNpfzy599") {
            UIApplication.shared.open(url)
        }
    }
}
