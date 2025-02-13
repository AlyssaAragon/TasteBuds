import SwiftUI

struct MainTabView: View {
    @StateObject private var favoritesManager = FavoritesManager() // Create the FavoritesManager instance

    var body: some View {
        TabView {
            CardView()
                .tabItem {
                    Image(systemName: "house.fill")
                }

            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                }
                .environmentObject(favoritesManager) // Inject the FavoritesManager into the environment

            SettingsView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
        }
        .accentColor(Color.black)
    }
}

#Preview {
    MainTabView()
}
