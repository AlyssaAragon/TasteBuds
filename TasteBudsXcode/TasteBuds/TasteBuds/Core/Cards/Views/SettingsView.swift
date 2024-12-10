// SettingsView.swift
// TasteBuds
//
// Created by Hannah Haggerty on 12/9/24.

import SwiftUI
//basic setup for now
struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Example content for the Settings screen
                Text("Adjust your preferences and settings here.")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()

                Spacer()
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
