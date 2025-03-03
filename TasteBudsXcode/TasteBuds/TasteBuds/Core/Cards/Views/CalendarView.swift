//
//  CalendarView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 2/27/25.
//

import SwiftUI

import SwiftUI

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
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(daysOfWeek, id: \.self) { day in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(day)
                                            .font(.headline)
                                            .frame(width: 100, alignment: .leading)
                                        Spacer()
                                        
                                        Menu {
                                            ForEach(favoritesManager.favoriteRecipes) { recipe in
                                                Button(recipe.name) {
                                                    calendarManager.addRecipe(to: day, recipe: recipe)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.bottom, 5)
                                    
                                    if let recipes = calendarManager.calendarRecipes[day], !recipes.isEmpty {
                                        VStack(alignment: .leading) {
                                            ForEach(recipes, id: \.id) { recipe in
                                                NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                                                    HStack {
                                                        Text(recipe.name)
                                                            .font(.subheadline)
                                                            .foregroundStyle(.black)
                                                        Spacer()
                                                        Button(action: {
                                                            calendarManager.removeRecipe(from: day, recipe: recipe)
                                                        }) {
                                                            Image(systemName: "xmark")
                                                                .foregroundColor(.red)
                                                        }
                                                    }
                                                    .padding(.vertical, 2)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(themeManager.selectedTheme == .highContrast ? 1.0 : 0.5)))
                            }
                        }
                        .padding()
                        .padding(.bottom, 50)
                    }
                }
                .padding()
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
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
            .environmentObject(CalendarManager())
    }
}


#Preview {
    CalendarView()
}
