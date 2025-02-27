import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @EnvironmentObject private var themeManager: ThemeManager //
    
    @State private var selectedTab: Tab = .home // Track the selected tab

    enum Tab {
        case home
        case favorites
        case settings
    }

    init() {
        // Set UITabBar appearance for solid white background
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content
            Group {
                switch selectedTab {
                case .home:
                    CardView()
                case .favorites:
                    FavoritesView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)

            // Custom Tab Bar (solid background, standard look)
            HStack {
                Spacer()
                tabBarItem(tab: .home, iconName: "house.fill")
                Spacer()
                tabBarItem(tab: .favorites, iconName: "heart.fill")
                Spacer()
                tabBarItem(tab: .settings, iconName: "person.fill")
                Spacer()
            }
            .frame(height: 100)
            .background(Color.white) // ✅ Solid white background
            .clipShape(Rectangle()) // ✅ Standard rectangular shape
            .padding(.bottom, -40)
        }
        .accentColor(.black)
    }

    // MARK: - Tab Bar Item View
    @ViewBuilder
    private func tabBarItem(tab: Tab, iconName: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 10) // ✅ Adds top padding to the icon
                    .padding(.bottom, 40)
                    .foregroundColor(selectedTab == tab ? .black : .gray)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(FavoritesManager())
        .environmentObject(ThemeManager())
}
