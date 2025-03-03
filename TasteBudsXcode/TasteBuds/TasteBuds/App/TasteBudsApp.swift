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
                        }
                    }
                    .id(isLoggedIn) // Force reset when login state changes
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

// Enum for views we can navigate to
enum NextView {
    case welcome  // Welcome screen
    case loginSignup  // Login/signup screen
    case addPartner  // Partner setup screen
    case dietaryPreferences  // Dietary preferences screen
    case cardView  // Main card view screen
}
