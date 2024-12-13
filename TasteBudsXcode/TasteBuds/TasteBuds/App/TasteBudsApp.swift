//Hannah Haggerty
import SwiftUI

@main
struct TasteBudsApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    @State private var isWelcomeViewPresented = true

    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
    }
// We need to seperate the tab view and main app files but for now this will have to do.
    var body: some Scene {
        WindowGroup {
            NavigationView {
            if isWelcomeViewPresented {
                WelcomeView()
                    .onDisappear {
                        isWelcomeViewPresented = false
                    }
            } else {
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
                    .navigationBarTitleDisplayMode(.inline)
                    .environmentObject(favoritesManager)
                    .accentColor(.blue)
                }
            }
        }
    }
}
