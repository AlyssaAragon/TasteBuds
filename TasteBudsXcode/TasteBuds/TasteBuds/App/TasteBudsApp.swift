// TasteBudsApp.swift
// TasteBuds
//
// Created by Hannah Haggerty on 11/19/24.

import SwiftUI

@main
struct TasteBudsApp: App {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                TabView {
                    // CardView with Home icon
                    CardView()
                        .tabItem {
                            Image(systemName: "house.fill") // Home icon
                                .font(.system(size: 40)) // Icon size
                                .foregroundColor(.black) // Icon color
                        }
                    
                    // SettingsView with Gear icon
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gearshape.fill") // Gear icon for settings
                                .font(.system(size: 40)) // Icon size
                                .foregroundColor(.black) // Icon color
                        }
                    // FavoritesView with Heart icon
                    FavoritesView()
                        .tabItem {
                            Image(systemName: "heart.fill") // Heart icon for favorites
                                .font(.system(size: 40)) // Icon size
                                .foregroundColor(.black) // Icon color
                        }
                }
            } else {
                WelcomeView()
                    .onAppear {
                        hasLaunchedBefore = true
                    }
            }
        }
    }
}
