import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var calendarManager: CalendarManager
    @EnvironmentObject private var userFetcher: UserFetcher
    
    @State private var selectedTab: Tab = .home // Track the selected tab

    enum Tab {
        case home
        case matches
        case favorites
        case calendar
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
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Main Content
                Group {
                    switch selectedTab {
                    case .home:
                        CardView()
                    case .matches:
                        MatchesView()
                    case .favorites:
                        FavoritesView()
                    case .calendar:
                        CalendarView()
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
                    tabBarItem(tab: .matches, iconName: "heart.fill")
                    Spacer()
                    tabBarItem(tab: .favorites, iconName: "star.fill")
                    Spacer()
                    tabBarItem(tab: .calendar, iconName: "calendar")
                    Spacer()
                    tabBarItem(tab: .settings, iconName: "person.fill")
                    Spacer()
                }
                .frame(height: 100)
                .background(Color.white) // ✅ Solid white background
                .clipShape(Rectangle()) // ✅ Standard rectangular shape
                .padding(.bottom, -45)
            }
            .accentColor(.black)
        }
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
        .environmentObject(CalendarManager())
        .environmentObject(UserFetcher())
}
