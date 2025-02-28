//
//  CalendarManager.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 2/28/25.
//

import Foundation
import SwiftUI

class CalendarManager: ObservableObject {
    @Published var calendarRecipes: [String: [FetchedRecipe]] = [:] // Store multiple recipes per day
    
    @AppStorage("calendarRecipes") private var storedCalendarRecipes: Data = Data()

    init() {
        loadCalendarData()
    }

    // Function to add a recipe to a specific day
    func addRecipe(to day: String, recipe: FetchedRecipe) {
        if calendarRecipes[day] == nil {
            calendarRecipes[day] = []
        }
        calendarRecipes[day]?.append(recipe)
        saveCalendarData()
    }

    // Function to remove a recipe from a specific day
    func removeRecipe(from day: String, recipe: FetchedRecipe) {
        if let index = calendarRecipes[day]?.firstIndex(where: { $0.id == recipe.id }) {
            calendarRecipes[day]?.remove(at: index)
            if calendarRecipes[day]?.isEmpty == true {
                calendarRecipes.removeValue(forKey: day)
            }
            saveCalendarData()
        }
    }

    // Function to clear all recipes
    func clearCalendar() {
        calendarRecipes.removeAll()
        saveCalendarData()
    }

    // Save calendar data to UserDefaults
    private func saveCalendarData() {
        if let encoded = try? JSONEncoder().encode(calendarRecipes) {
            storedCalendarRecipes = encoded
        }
    }

    // Load calendar data from UserDefaults
    private func loadCalendarData() {
        if let decoded = try? JSONDecoder().decode([String: [FetchedRecipe]].self, from: storedCalendarRecipes) {
            calendarRecipes = decoded
        }
    }
}
