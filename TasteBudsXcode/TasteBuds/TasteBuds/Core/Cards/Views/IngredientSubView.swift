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
    @Namespace var scrollSpace
    let ingredients = [
        ("Milk", ["Almond Milk: A good non-dairy substitute. Use in smoothies, baking, or cooking.", "Soy Milk: A protein-rich substitute, great for cooking and baking.", "Oat Milk: A mild flavor substitute, great for coffee or cereal."]),
        ("Eggs", ["Chia Seeds: Use 1 tbsp chia seeds + 3 tbsp water as an egg substitute in baking.", "Applesauce: 1/4 cup applesauce can replace 1 egg in baking.", "Yogurt: 1/4 cup yogurt can replace 1 egg in baking."]),
        ("Cheese", ["Nutritional Yeast: A cheesy flavor, great for vegans. Use in pasta or on popcorn.", "Cashew Cheese: A creamy, vegan cheese. Great for spreads and dips.", "Tofu Cheese: A firm tofu alternative. Can be used in sandwiches or salads."]),
        ("Meat", ["Tofu: A great protein-packed substitute, use in stir-fries or grilled dishes.", "Tempeh: A fermented soy product, great for tacos, sandwiches, or salads.", "Mushrooms: A meaty texture, great for burgers, stir-fries, or as a main dish."]),
        ("Salt", ["Soy Sauce / Tamari: Use for savory depth in cooked dishes.", "Miso Paste: Adds saltiness plus umami, especially in soups or marinades.", "Herbs & Spices: Add flavor with no sodium — try garlic powder, smoked paprika, etc." ]),
        ("Butter", [ "Coconut Oil: Use in baking 1:1. Adds slight coconut flavor.", "Applesauce: Use 1/2 cup for 1 cup butter in baking for a lower-fat option.", "Olive Oil: Use 3/4 cup olive oil for every 1 cup of butter in cooking or baking." ]),
        ("Flour", [ "Almond Flour: Great for gluten-free baking. May need adjustments in moisture.", "Oat Flour: Can sub 1:1 but works best in muffins, pancakes, etc.", "Coconut Flour: Very absorbent, use 1/4 cup for every 1 cup flour and add extra eggs." ]),
    ]
    
    private func flippableIngredientCard(ingredient: String, substitutes: [String]) -> some View {
        let isSelected = selectedCard == ingredient
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth:CGFloat = isSelected ? screenWidth - 40 : (screenWidth / 2) - 24
        let cardHeight:CGFloat = isSelected ? 360 : 130

        return VStack {
            ZStack {
                if isSelected {
                    backOfIngredientCard(substitutes: substitutes)
                        .transition(.opacity)
                } else {
                    frontOfIngredientCard(ingredient: ingredient)
                        .transition(.opacity)
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedCard = isSelected ? nil : ingredient
                }
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .zIndex(isSelected ? 1 : 0)
    }
    
    private func frontOfIngredientCard(ingredient: String) -> some View {
        Text(ingredient)
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(Color.customYellow)
            .foregroundColor(.black)
            .cornerRadius(12)
            .padding(.vertical)
    }
    
    private func backOfIngredientCard(substitutes: [String]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Substitutes:")
                    .font(.subheadline)
                    .bold()
                    .padding(.bottom, 5)

                ForEach(substitutes, id: \.self) { substitute in
                    HStack(alignment: .top) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .foregroundColor(.black)
                            .padding(.top, 5)

                        Text(substitute)
                            .font(.body)
                            .padding(.horizontal, 10)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.customPink)
        .foregroundColor(.black)
        .cornerRadius(12)
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

struct IngredientSubView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientSubView()
    }
}

