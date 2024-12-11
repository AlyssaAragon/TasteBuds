import SwiftUI

@main
struct TasteBudsApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    @State private var isWelcomeViewPresented = true

    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                //WelcomeView()
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
