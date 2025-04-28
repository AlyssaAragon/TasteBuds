import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var userFetcher: UserFetcher

    @State private var showingLogoutAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack(spacing: 0) {
                        Text("Settings")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity)

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
                            NavigationLink(destination: AddPartnerView()
                            .environmentObject(navigationState)){
                                settingsRow(title: "Partner")
                            }
                    
                    Divider()
                    
                    NavigationLink(destination: ChangePasswordView()) {
                        settingsRow(title: "Change Password")
                    }
                            Divider()

                            NavigationLink(destination: DietaryPreferencesView()
                                .environmentObject(navigationState)
                            )
                            {
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

                            NavigationLink(destination: IngredientSubView()) {
                                settingsRow(title: "Common Ingredient Substitutions")
                            }
                            Divider()
                            
                            NavigationLink(destination: TutorialGalleryView()) {
                                settingsRow(title: "Tutorial")
                            }
                            Divider()

                            NavigationLink(destination: PrivacySecurityView()) {
                                settingsRow(title: "Privacy & Security")
                            }
                            Divider()

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
                        if userFetcher.currentUser == nil {
                            await userFetcher.fetchUser()
                        }
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


}


#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(NavigationState())
        .environmentObject(UserFetcher())
}
