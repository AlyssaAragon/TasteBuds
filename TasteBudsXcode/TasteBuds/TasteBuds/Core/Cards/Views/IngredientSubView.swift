//
//  IngredientSubView.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 4/2/25.
//

import SwiftUI
struct IngredientSubView: View {
    @State private var flippedIndex: Int? = nil
    @State private var selectedCard: String?
    let ingredients = [
        ("Milk", ["Almond Milk: A good non-dairy substitute. Use in smoothies, baking, or cooking.",
                  "Soy Milk: A protein-rich substitute, great for cooking and baking.",
                  "Oat Milk: A mild flavor substitute, great for coffee or cereal."]),
        ("Eggs", ["Chia Seeds: Use 1 tbsp chia seeds + 3 tbsp water as an egg substitute in baking.",
                  "Applesauce: 1/4 cup applesauce can replace 1 egg in baking.",
                  "Yogurt: 1/4 cup yogurt can replace 1 egg in baking."]),
        ("Cheese", ["Nutritional Yeast: A cheesy flavor, great for vegans. Use in pasta or on popcorn.",
                    "Cashew Cheese: A creamy, vegan cheese. Great for spreads and dips.",
                    "Tofu Cheese: A firm tofu alternative. Can be used in sandwiches or salads."]),
        ("Meat", ["Tofu: A great protein-packed substitute, use in stir-fries or grilled dishes.",
                  "Tempeh: A fermented soy product, great for tacos, sandwiches, or salads.",
                  "Mushrooms: A meaty texture, great for burgers, stir-fries, or as a main dish."])
    ]
    
    private func flippableIngredientCard(ingredient: String, substitutes: [String]) -> some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    frontOfIngredientCard(ingredient: ingredient, geometry: geometry)
                        .opacity(selectedCard == ingredient ? 0.0 : 1.0)
                        
                    backOfIngredientCard(substitutes: substitutes, geometry: geometry)
                        .opacity(selectedCard == ingredient ? 1.0 : 0.0)
                }
                .frame(width: geometry.size.width - 20, height: selectedCard == ingredient ? 350 : 120)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .onTapGesture {
                    withAnimation {
                        selectedCard = (selectedCard == ingredient) ? nil : ingredient
                    }
                }
            }
        }
        .frame(height: selectedCard == ingredient ? 360 : 130)
        .zIndex(selectedCard == ingredient ? 1 : 0)
    }
        
    
    private func frontOfIngredientCard(ingredient: String, geometry: GeometryProxy) -> some View {
        Text(ingredient)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 120)
            .background(Color.customYellow)
            .foregroundColor(.black)
            .cornerRadius(12)
            .padding(.vertical)
    }
    
    private func backOfIngredientCard(substitutes: [String], geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("Substitutes:")
                .font(.subheadline)
                .bold()
                .padding(.bottom, 5)
            ForEach(substitutes, id: \.self) { substitute in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(.black)
                    Text(substitute)
                        .font(.body)
                        .padding(.horizontal, 10)
                }
            }
        }
        .frame(width: geometry.size.width - 40, height: 320)
        .background(Color.customPink)
        .foregroundColor(.black)
        .cornerRadius(12)
        .padding()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Common Ingredient Substitutions")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
            
            Text("Tap on an ingredient to see common substitutes and how to use them in your cooking. Find new alternatives to fit your dietary needs!")
                .font(.body)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(ingredients, id: \.0) { ingredientData in
                        flippableIngredientCard(ingredient: ingredientData.0, substitutes: ingredientData.1)
                    }
                }
                .padding(.top)
            }
        }
        .padding()
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
struct IngredientSubView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientSubView()
    }
}

