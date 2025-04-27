import SwiftUI
import Foundation

extension FetchedRecipe {
    init(from cravingRecipe: CravingRecipe) {
        self.id = cravingRecipe.recipeid
        self.name = cravingRecipe.title
        self.ingredients = cravingRecipe.ingredients
        self.instructions = cravingRecipe.instructions
        self.imageName = cravingRecipe.image_name
        self.cleanedIngredients = cravingRecipe.cleaned_ingredients
    }
}

struct CravingPopupView: View {
    @State private var showPopup = false
    @State private var selectedRecipe: FetchedRecipe? = nil
    @State private var selectedCategory: String? = nil
    @State private var showSaveBanner = false
    @EnvironmentObject private var favoritesManager: FavoritesManager
    let categories = ["meal", "drink", "dessert"]

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

                    Button(action: {
                        if let random = categories.randomElement() {
                            fetchCravingRecommendation(category: random)
                        }
                    }) {
                        Text("Anything!")
                            .padding()
                            .background(Color.customGreen)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
            if showSaveBanner {
                Text("Recipe Saved!")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(10)
                    .transition(.opacity)
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

                        Text(selectedRecipe.name)
                            .font(.title)
                            .bold()
                            .padding(.bottom, 5)

                        if let imageUrl = selectedRecipe.imageName, let url = URL(string: imageUrl) {
                            AsyncImage(url: url)
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        }

                        Text(selectedRecipe.cleanedIngredients)
                            .padding()

                        Text(selectedRecipe.instructions)
                            .padding()

                        HStack {
                            Button("Save") {
                                let fetchedRecipe = FetchedRecipe(from: selectedRecipe)
                                favoritesManager.addFavorite(fetchedRecipe)
                                withAnimation {
                                    favoritesManager.addFavorite(selectedRecipe)
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
                    .padding()
                    .frame(maxWidth: 350, maxHeight: 600)
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
        guard let url = URL(string: "https://tastebuds.unr.dev/api/get_random_recipe_by_category/?category=\(category)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let decodedRecipe = try? JSONDecoder().decode(FetchedRecipe.self, from: data) {
                    self.selectedRecipe = decodedRecipe
                } else {
                    print("unable to fetch craving recipe")
                }
                self.showPopup = true
            }
        }.resume()
    }

    func showSaveConfirmation() {
        withAnimation {
            showSaveBanner = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showSaveBanner = false
                showPopup = false
            }
        }
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
