//
//  CalendarView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 2/27/25.
//

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


    @StateObject private var userFetcher = UserFetcher()
    @State private var isLoading = false
    @State private var selectedDay: SelectedDay? = nil


    private var currentUser: FetchedUser? {
        userFetcher.currentUser
    }

    private var partnerUsername: String? {
        userFetcher.currentUser?.partner?.username
    }

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
                            Section(header: HStack {
                                Text(day)
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                                Spacer()
                                Button(action: {
                                    selectedDay = SelectedDay(value: day)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(Color.primary)
                                        .font(.system(size: 20))
                                }
                            }) {
                                if let recipes = calendarManager.calendarRecipes[day], !recipes.isEmpty {
                                    ForEach(recipes, id: \.id) { recipe in
                                        VStack(alignment: .leading) {
                                            HStack {
                                                NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                                                    Text(recipe.name)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.primary)
                                                }
                                                Spacer()
                                                Menu {
                                                    if let username = currentUser?.username {
                                                        Button("Assign to You") {
                                                            calendarManager.assignRecipe(recipe, to: [username], on: day)
                                                        }
                                                    }
                                                    if let partner = partnerUsername {
                                                        Button("Assign to \(partner)") {
                                                            calendarManager.assignRecipe(recipe, to: [partner], on: day)
                                                        }
                                                    }
                                                    if let username = currentUser?.username, let partner = partnerUsername {
                                                        Button("Assign to Both") {
                                                            calendarManager.assignRecipe(recipe, to: [username, partner], on: day)
                                                        }
                                                    }
                                                } label: {
                                                    Image(systemName: "person.crop.circle.badge.plus")
                                                        .foregroundStyle(.blue)
                                                }
                                            }
                                            if let assigned = recipe.assignedToUsernames, !assigned.isEmpty {
                                                Text("Assigned to: \(assigned.joined(separator: ", "))")
                                                    .font(.caption)
                                                    .foregroundColor(.green)
                                            }
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
                                        .foregroundColor(.secondary)
                                        .italic()
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .id(UUID())
                    .padding(.bottom, 50)
                }
                .navigationBarItems(trailing: Button(action: {
                    calendarManager.clearCalendar()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundStyle(.red)
                })
            }
        }
        .onAppear {
            favoritesManager.fetchUserFavorites()
        }
        .task {
            await fetchPartnerInfo()
        }
        .sheet(item: $selectedDay) { selectedDay in
            RecipePickerSheet(selectedDay: selectedDay.value)
                .environmentObject(favoritesManager)
                .environmentObject(calendarManager)
        }
    }


    private func fetchPartnerInfo() async {
        isLoading = true
        await userFetcher.fetchUser()
        isLoading = false
    }

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

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
            .environmentObject(CalendarManager())
    }
}

struct SelectedDay: Identifiable {
    let id = UUID()
    let value: String
}


#Preview {
    CalendarView()
}