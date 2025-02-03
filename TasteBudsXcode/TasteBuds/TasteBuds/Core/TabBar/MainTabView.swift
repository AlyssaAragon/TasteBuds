import SwiftUI

struct MainTabView: View {
    @StateObject private var favoritesManager = FavoritesManager() // Create the FavoritesManager instance

    var body: some View {
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
                .environmentObject(favoritesManager) // Inject the FavoritesManager into the environment

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Color.black)
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
