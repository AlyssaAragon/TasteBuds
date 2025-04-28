//
//  SavedRecipesTabView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 3/2/25.
//

import SwiftUI

struct SavedRecipesTabView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var selectedTab: Int = 0
    
    let tabs: [Tab] = [
        .init(icon: Image(systemName: "music.note"), title: "Matches"),
        .init(icon: Image(systemName: "heart.fill"), title: "Favorites")
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // Tabs
                    Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                    
                    // Views
                    TabView(selection: $selectedTab) {
                        MatchesView()
                            .tag(0)
                        FavoritesView()
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .background(themeManager.selectedTheme.backgroundView.ignoresSafeArea()) // Apply theme background with ignoresSafeArea to prevent bleeding
                .foregroundColor(themeManager.selectedTheme.textColor) // Apply theme text color
                .navigationBarTitle("Recipes", displayMode: .inline)
            }
        }
//        .accentColor(themeManager.selectedTheme.primaryColor) // Ensure tab highlight matches theme
    }
}

#Preview {
    SavedRecipesTabView()
        .environmentObject(FavoritesManager())
        .environmentObject(ThemeManager())
}
