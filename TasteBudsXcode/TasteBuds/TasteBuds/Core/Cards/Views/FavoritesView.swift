// FavoritesView.swift
// TasteBuds
//
// Created by Hannah Haggerty on 12/9/24.

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Example content for the Favorites screen
                Text("This is where your favorite recipes will appear.")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()

                Spacer()
            }
            .navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
