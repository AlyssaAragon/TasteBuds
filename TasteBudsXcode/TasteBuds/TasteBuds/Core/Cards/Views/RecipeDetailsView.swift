//
//  RecipeDetailsView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 3/3/25.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var recipe: FetchedRecipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(recipe.name)
                    .font(.system(size: themeManager.textSize.size + 6)) // slightly larger for the title
                    .bold()
                    .padding()
                
                if let url = recipe.imageUrl {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
//                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                    } placeholder: {
//                        Image("placeholder")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: .infinity)
//                            .cornerRadius(10)
                    }
                    .padding()
                }
                
                Text("Ingredients")
                    .font(.system(size: themeManager.textSize.size))
                    .bold()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 15)
                
                let cleanedIngredients = recipe.ingredients
                    .trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
                    .components(separatedBy: "', '")
                    .map { $0.replacingOccurrences(of: "'", with: "").trimmingCharacters(in: .whitespacesAndNewlines) }
                
                ForEach(cleanedIngredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                        .font(.system(size: themeManager.textSize.size))
                        .padding(.horizontal)
                }
                
                Text("Instructions")
                    .font(.system(size: themeManager.textSize.size))
                    .bold()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 15)

                
                Text(recipe.instructions)
                    .font(.system(size: themeManager.textSize.size))
                    .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
        }
        .navigationTitle("Recipe Details")
        .tint(Color.primary)
    }
}

#Preview {
    RecipeDetailsView(recipe: FetchedRecipe(
        id: 1,
        name: "Sample Recipe",
        ingredients: "Salt and pepper",
        instructions: "['Salt', 'Pepper']",
        imageName: "placeholder",
        cleanedIngredients: "Mix and cook."
    ))
    .environmentObject(ThemeManager())
}

