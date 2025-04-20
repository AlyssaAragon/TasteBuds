//
//  CalendarView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 2/27/25.
//

import SwiftUI

extension String {
    var titleCase: String {
        self.lowercased().split(separator: " ").map { $0.capitalized }.joined(separator: " ")
    }
}

struct CalendarView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var calendarManager: CalendarManager

    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.selectedTheme.backgroundView
                VStack {
                    Text("Weekly Meal Planner")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, -40)

                    List {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Section(header: sectionHeader(for: day)) {
                                if let recipes = calendarManager.calendarRecipes[day], !recipes.isEmpty {
                                    ForEach(recipes, id: \.id) { recipe in
                                        NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                                            Text(recipe.name)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .onDelete { indexSet in
                                        indexSet.forEach { index in
                                            let recipe = recipes[index]
                                            calendarManager.removeRecipe(from: day, recipe: recipe)
                                        }
                                    }
                                } else {
                                    Text("No recipes planned")
                                        .foregroundColor(.gray)
                                        .italic()
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .id(UUID())
                    .background(themeManager.selectedTheme.backgroundView)
                    .padding(.bottom, 50)
                }
                .navigationBarItems(trailing: Button(action: {
                    calendarManager.clearCalendar()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                })
            }
        }
    }

    // ✅ MOVE THIS INSIDE CalendarView
    @ViewBuilder
    private func sectionHeader(for day: String) -> some View {
        HStack {
            Text(day)
                .font(.title3)
                .foregroundStyle(.black)
            Spacer()
            Menu {
                ForEach(favoritesManager.favoriteRecipes) { wrapper in
                    Button(wrapper.recipe.name.titleCase) {
                        calendarManager.addRecipe(to: day, recipe: wrapper.recipe)
                    }
                }

            } label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.black)
                    .font(.system(size: 20))
            }
        }
    }
}

#Preview {
    CalendarView()
}
