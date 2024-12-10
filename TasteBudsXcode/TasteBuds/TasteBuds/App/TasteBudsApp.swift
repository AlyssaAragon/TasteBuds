import SwiftUI

@main
struct TasteBudsApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
                    .environmentObject(favoritesManager)
            } else {
                WelcomeView()
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            CardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .accentColor(.primary)
    }
}
