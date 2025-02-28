//
//  CalendarView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 2/27/25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager

    @State private var calendarRecipes: [String: [FetchedRecipe]] = [:] // Store multiple recipes per day

    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    themeManager.selectedTheme.backgroundView

                    VStack {
                        Text("Weekly Meal Planner")
                            .font(.title.bold())
                            .padding(.top, geometry.size.height * -0.04)

                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(day)
                                                .font(.headline)
                                                .frame(width: 100, alignment: .leading)
                                            Spacer()
                                            
                                            // Add recipe button
                                            Menu {
                                                ForEach(favoritesManager.favoriteRecipes) { recipe in
                                                    Button(recipe.name) {
                                                        if calendarRecipes[day] == nil {
                                                            calendarRecipes[day] = []
                                                        }
                                                        calendarRecipes[day]?.append(recipe) // Append instead of replacing
                                                    }
                                                }
                                            } label: {
                                                Image(systemName: "plus.circle")
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        .padding(.bottom, 5)

                                        // Display added recipes
                                        if let recipes = calendarRecipes[day], !recipes.isEmpty {
                                            VStack(alignment: .leading) {
                                                ForEach(recipes, id: \.id) { recipe in
                                                    HStack {
                                                        Text(recipe.name)
                                                            .font(.subheadline)
                                                        Spacer()
                                                        Button(action: {
                                                            if let index = calendarRecipes[day]?.firstIndex(where: { $0.id == recipe.id }) {
                                                                calendarRecipes[day]?.remove(at: index)
                                                                if calendarRecipes[day]?.isEmpty == true {
                                                                    calendarRecipes.removeValue(forKey: day) // Remove key if empty
                                                                }
                                                            }
                                                        }) {
                                                            Image(systemName: "trash")
                                                                .foregroundColor(.red)
                                                        }
                                                    }
                                                    .padding(.vertical, 2)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.25)))
                                }
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
                .navigationBarItems(trailing: Button(action: {
                    calendarRecipes.removeAll()
                }) {
                    Image(systemName: "x.circle")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.red)
                })
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
    }
}


#Preview {
    CalendarView()
}
