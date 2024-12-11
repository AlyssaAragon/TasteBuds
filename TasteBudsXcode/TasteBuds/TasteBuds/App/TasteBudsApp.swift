import SwiftUI

@main
struct TasteBudsApp: App {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @StateObject private var favoritesManager = FavoritesManager()

    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().frame.size.height = 100
    }

    var body: some Scene {
        WindowGroup {
            if !hasLaunchedBefore {
                WelcomeView()
                    .onAppear {
                        hasLaunchedBefore = true
                    }
            } else {
                TabView {
                    CardView()
                        .tabItem {
                            Image(systemName: "house.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color.black)
                        }

                    FavoritesView()
                        .tabItem {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color.black)
                        }

                    SettingsView()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color.black)
                        }
                }
                .environmentObject(favoritesManager)
                .accentColor(.blue)
            }
        }
    }
}
