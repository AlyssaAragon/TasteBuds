import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var calendarManager: CalendarManager
    @EnvironmentObject private var userFetcher: UserFetcher
    @EnvironmentObject private var navigationState: NavigationState

    @State private var selectedTab: Tab = .home
    @State private var showCravingPopup = false
    @State private var path = NavigationPath()

    enum Tab {
        case home
        case matches
        case favorites
        case calendar
        case settings
    }

    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                currentTabView()

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
                .background(Color.white)
                .clipShape(Rectangle())
                .padding(.bottom, -45)
            }
            .accentColor(.black)
            .sheet(isPresented: $showCravingPopup) {
                CravingPopupView()
            }
            .navigationDestination(for: NextView.self) { destination in
                switch destination {
                case .partnerSetup:
                    PartnerSetupView(isNewUserPassed: true)
                        .environmentObject(navigationState)
                case .dietaryPreferences:
                    DietaryPreferencesView()
                        .environmentObject(navigationState)
                case .settings:
                    SettingsView()
                        .environmentObject(navigationState)
                        .environmentObject(userFetcher)
                default:
                    EmptyView()
                }
            }
            .onChange(of: navigationState.nextView) { newValue in
                if newValue != .cardView, newValue != .welcome {
                    path.append(newValue)
                    navigationState.nextView = .cardView
                }
            }


            .onAppear {
                if CravingManager.shared.allowCravingPopup() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCravingPopup = true
                        CravingManager.shared.updateLastPopupDate() 
                    }
                }
            }

        }
    }

    @ViewBuilder
    private func currentTabView() -> some View {
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

    @ViewBuilder
    private func tabBarItem(tab: Tab, iconName: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                    .foregroundColor(selectedTab == tab ? .black : .gray)
            }
        }
    }
}
