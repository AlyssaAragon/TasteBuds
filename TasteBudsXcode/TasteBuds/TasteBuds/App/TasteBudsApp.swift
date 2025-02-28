import SwiftUI

@main
struct TasteBudsApp: App {
    // user's state variables
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @AppStorage("isNewUser") private var isNewUser = false
    
    // this object stores and tracks the navigation state for the app.
    @StateObject private var navigationState = NavigationState()
    
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var calendarManager = CalendarManager()

    var body: some Scene {
        WindowGroup {
            // NavigationStack is used in iOS 16+ so I switched out NavigationViews to NavigationStack
            NavigationStack {
                // Main view where we listen to the navigation state and show the correct view
                switch navigationState.nextView {
                case .welcome:
                    WelcomeView()
                        .onAppear {
                            // Set the next view when WelcomeView finishes
                            hasSeenWelcome = true  // Mark that user has seen welcome
                            navigationState.nextView = .loginSignup
                        }
                case .loginSignup:
                    LoginSignupView(navigationState: navigationState) // Pass the navigation state to LoginSignupView
                case .addPartner:
                    AddPartnerView()
                        .onAppear {
                            // Set the next view when AddPartnerView finishes
                            navigationState.nextView = .dietaryPreferences
                        }
                case .dietaryPreferences:
                    DietaryPreferencesView()
                        .onAppear {
                            // Once DietaryPreferencesView finishes, go to CardView
                            navigationState.nextView = .cardView
                        }
                case .cardView:
                    MainTabView()
                        .environmentObject(favoritesManager)
                        .environmentObject(themeManager)
                        .environmentObject(calendarManager)
                        .onAppear {
                            // Set any additional logic once in CardView, if needed
                        }
                }
            }
        }
    }
}

// Object used to store and track the navigation state of the app
class NavigationState: ObservableObject {
    // This holds the current view that should be displayed.
    @Published var nextView: NextView = .welcome
}

// Enum for views we can navigate to
enum NextView {
    case welcome  // Welcome screen
    case loginSignup  // Login/signup screen
    case addPartner  // Partner setup screen
    case dietaryPreferences  // Dietary preferences screen
    case cardView  // Main card view screen
}
