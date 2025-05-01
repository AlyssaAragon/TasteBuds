import SwiftUI

@main
struct TasteBudsApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false
    @AppStorage("isGuestUser") private var isGuestUser = false

    @StateObject private var navigationState = NavigationState()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var userFetcher = UserFetcher()
    
    @State private var showSessionExpiredAlert = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn && !isNewUser {
                    NavigationStack {
                        MainTabView()
                            .environmentObject(favoritesManager)
                            .environmentObject(themeManager)
                            .environmentObject(calendarManager)
                            .environmentObject(navigationState)
                            .environmentObject(userFetcher)
                    }
                } else if isGuestUser {
                    NavigationStack {
                        MainTabView()
                            .environmentObject(favoritesManager)
                            .environmentObject(themeManager)
                            .environmentObject(calendarManager)
                            .environmentObject(navigationState)
                            .environmentObject(userFetcher)
                    }
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
                                .environmentObject(navigationState)
                        case .partnerSetup:
                            PartnerSetupView(isNewUserPassed: true)
                                .environmentObject(navigationState)
                        case .tutorial:
                            TutorialGalleryView()
                                .environmentObject(navigationState)
                        case .dietaryPreferences:
                            DietaryPreferencesView()
                                .environmentObject(navigationState)
                        case .cardView:
                            MainTabView()
                                .environmentObject(favoritesManager)
                                .environmentObject(themeManager)
                                .environmentObject(calendarManager)
                                .environmentObject(userFetcher)
                                .environmentObject(navigationState)
                        case .settings:
                            SettingsView()
                                .environmentObject(navigationState)
                                .environmentObject(userFetcher)
                        }
                    }
                }

            }
            .alert("Session expired", isPresented: $showSessionExpiredAlert) {
                Button("Log Out", role: .destructive) {
                    AuthService.shared.logout()
                    userFetcher.currentUser = nil
                    userFetcher.sessionExpired = false
                    isLoggedIn = false
                    isNewUser = false
                    isGuestUser = false
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
            .onAppear {
                Task {
                    if isLoggedIn {
                        do {
                            try await AuthService.shared.ensureValidToken()
                            await userFetcher.fetchUser()
                        } catch {
                            print("Failed to refresh token: \(error)")
                            showSessionExpiredAlert = true
                        }
                    }
                }

            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task {
                    if isLoggedIn && !isGuestUser {
                        await userFetcher.fetchUser()
                    }
                }
            }

        }
    }
}


enum NextView: Hashable {
    case welcome
    case loginSignup
    case addPartner
    case partnerSetup
    case tutorial
    case dietaryPreferences
    case cardView
    case settings
}


class NavigationState: ObservableObject {
    @Published var nextView: NextView = .welcome
    @Published var previousView: NextView?
    @Published var presentedView: PresentedView?
    
    func goBack() {
        if let previous = previousView {
            nextView = previous
        }
    }
}

struct PresentedView: Identifiable {
    let id = UUID()
    let viewType: NextView
}
