//
//  RecipePickerSheet.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 4/27/25.
//

import SwiftUI

struct RecipePickerSheet: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var calendarManager: CalendarManager

    @Environment(\.dismiss) var dismiss

    var selectedDay: String

    @State private var searchText: String = ""

    var filteredRecipes: [FetchedRecipe] {
        if searchText.isEmpty {
            return favoritesManager.favoriteRecipes
        } else {
            return favoritesManager.favoriteRecipes.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredRecipes) { recipe in
                Button(action: {
                    calendarManager.addRecipe(to: selectedDay, recipe: recipe)
                    dismiss()
                }) {
                    Text(recipe.name.titleCase)
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle("Pick a Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search recipes")
        }
    }
}


#Preview {
    RecipePickerSheet(   selectedDay: "Monday")
}
