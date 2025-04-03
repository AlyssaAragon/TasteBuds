import SwiftUI

@main
struct TasteBudsApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false

    @StateObject private var navigationState = NavigationState()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var userFetcher = UserFetcher()

    @State private var showSessionExpiredAlert = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    MainTabView()
                        .environmentObject(favoritesManager)
                        .environmentObject(themeManager)
                        .environmentObject(calendarManager)
                        .environmentObject(navigationState)
                        .environmentObject(userFetcher)
                } else {
                    NavigationStack {
                        switch navigationState.nextView {
                        case .welcome:
                            WelcomeView()
                                .environmentObject(navigationState)
                        case .loginSignup:
                            LoginSignupView(navigationState: navigationState)
                        case .addPartner:
                            AddPartnerView()
                                .onAppear {
                                    navigationState.nextView = .dietaryPreferences
                                }
                        case .dietaryPreferences:
                            DietaryPreferencesView()
                                .onAppear {
                                    navigationState.nextView = .cardView
                                }
                        case .cardView:
                            MainTabView()
                                .environmentObject(favoritesManager)
                                .environmentObject(themeManager)
                                .environmentObject(calendarManager)
                                .environmentObject(userFetcher)
                        case .settings:
                            SettingsView()
                                .environmentObject(navigationState)
                                .environmentObject(userFetcher)

                        }
                    }
                    .id(isLoggedIn) // Force reset when login state changes
                }
            }
            .alert("Session expired", isPresented: $showSessionExpiredAlert) {
                Button("Log Out", role: .destructive) {
                    AuthService.shared.logout()
                    userFetcher.currentUser = nil
                    userFetcher.sessionExpired = false
                    isLoggedIn = false
                    isNewUser = false
                    navigationState.nextView = .loginSignup
                }
            } message: {
                Text("Your login session has expired. Please sign in again.")
            }


            .onReceive(userFetcher.$sessionExpired) { expired in
                if expired {
                    showSessionExpiredAlert = true
                }
            }

            // checks the token when app starts
            .onAppear {
                Task {
                    if isLoggedIn {
                        await AuthService.shared.refreshTokenIfNeeded { _ in }
                        await userFetcher.fetchUser()
                    }
                }
            }


            //Always re-check token when app resumes
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task {
                    if isLoggedIn {
                        await userFetcher.fetchUser()
                    }
                }
            }
        }
    }
}

class NavigationState: ObservableObject {
    @Published var nextView: NextView = .welcome
    @Published var previousView: NextView?

    func goBack() {
        if let previous = previousView {
            nextView = previous
        }
    }
}

enum NextView {
    case welcome              // Welcome screen
    case loginSignup          // Login/signup screen
    case addPartner           // Partner setup screen
    case dietaryPreferences   // Dietary preferences screen
    case cardView             // Main card view screen
    case settings
}
