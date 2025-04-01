//
//  CravingPopupView.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 3/26/25.
//
import SwiftUI
import Foundation

struct CravingPopupView: View {
    @State private var showPopup = false
    @State private var selectedRecipe: CravingRecipe? = nil
    @State private var selectedCategory: String? = nil
    @EnvironmentObject private var favoritesManager: FavoritesManager
    let categories = ["Meal", "Drink", "Dessert"]

    var body: some View {
        VStack(spacing: 20) {
            if showPopup {
                Text("Here’s a recipe based on your craving!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineLimit(2)
            } else {
                Text("What are you craving?")
                    .font(.headline)
                    .foregroundColor(.brown)
            }
            if !showPopup {
                HStack {
                    Button(action: { fetchCravingRecommendation(category: "meal") }) {
                        Text("Meal")
                            .padding()
                            .background(Color.customYellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }

                    Button(action: { fetchCravingRecommendation(category: "drink") }) {
                        Text("Drink")
                            .padding()
                            .background(Color.customOrange)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }

                HStack {
                    Button(action: { fetchCravingRecommendation(category: "dessert") }) {
                        Text("Dessert")
                            .padding()
                            .background(Color.customBlue)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }

                    Button(action: { fetchCravingRecommendation(category: categories.randomElement()!) }) {
                        Text("Anything!")
                            .padding()
                            .background(Color.customGreen)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }

            if showPopup, let selectedRecipe = selectedRecipe {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { showPopup = false }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                        .padding([.top, .trailing])

                        Text(selectedRecipe.title)
                            .font(.title)
                            .bold()
                            .padding(.bottom, 5)

                        if let imageUrl = selectedRecipe.image_name, let url = URL(string: imageUrl) {
                            AsyncImage(url: url)
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        }

                        Text(selectedRecipe.cleaned_ingredients)
                            .padding()

                        Text(selectedRecipe.instructions)
                            .padding()

                        HStack {
                            Button("Save") {
                                withAnimation {
                                    showSaveConfirmation()
                                }
                            }
                            .padding()
                            .background(Color.customPink)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                            Button("Show Another") {
                                if let currentCategory = selectedCategory {
                                    fetchCravingRecommendation(category: currentCategory)
                                }
                            }
                            .padding()
                            .background(Color.customPurple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.bottom)
                    }
                    .frame(width: 320, height: 700)
                    .background(Color.customYellow)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding()
                }
            }
        }
        .padding()
    }

    func fetchCravingRecommendation(category: String) {
        selectedCategory = category
        let url = URL(string: "https://tastebuds.unr.dev/api/get_random_recipe_by_category/?category=\(category)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let data = data, let decodedResponse = try? JSONDecoder().decode(CravingRecipe.self, from: data) {
                        self.selectedRecipe = decodedResponse
                    } else {
                        print("unable to fetch craving recipe")
                    }
                    self.showPopup = true
                }
            }.resume()
    }
    func showSaveConfirmation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showPopup = false
            }
        }
    }
}

struct CravingRecipe: Codable {
    let recipeid: Int
    let title: String
    let ingredients: String
    let instructions: String
    let image_name: String?
    let cleaned_ingredients: String
    
    enum CodingKeys: String, CodingKey {
        case recipeid
        case title
        case ingredients
        case instructions
        case image_name
        case cleaned_ingredients
    }
}

extension Color {
    static let customPink = Color(red: 250/255, green: 178/255, blue: 200/255)
    static let customBlue = Color(red: 121/255, green: 173/255, blue: 220/255)
    static let customOrange = Color(red: 244/255, green: 185/255, blue: 102/255)
    static let customGreen = Color(red: 204/255, green: 226/255, blue: 163/255)
    static let customPurple = Color(red: 194/255, green: 132/255, blue: 190/255)
    static let customYellow = Color(red: 250/255, green: 242/255, blue: 161/255)
}

