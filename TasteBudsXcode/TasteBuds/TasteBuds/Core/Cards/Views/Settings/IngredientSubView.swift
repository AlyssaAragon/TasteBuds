import SwiftUI

struct IngredientSubView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var flippedIndex: Int? = nil
    @State private var selectedCard: String?
    
    @Namespace var scrollSpace

    let ingredients = [
        ("Milk", ["Rice Milk: A lighter, non-dairy alternative. Best for drinking or light cooking. Not as creamy as dairy milk.", "Almond Milk: A non-dairy substitute, good for smoothies and cereal, but thinner texture.", "Soy Milk: A protein-rich substitute, good for baking and cooking. Slightly thicker than other plant milks."]),
        ("Eggs", ["Flaxseed: Mix 1 tbsp flaxseed meal + 3 tbsp water for a baking egg substitute. Slightly nutty flavor.","Chia Seeds: 1 tbsp chia seeds + 3 tbsp water replaces 1 egg in baking.", "Applesauce: 1/4 cup replaces 1 egg in baking for moisture, but doesn't bind or emulsify like eggs."]),
        ("Cheese", ["Strong Cheese (like Parmesan): Use less of a strong cheese for more flavor and better nutrition.", "Nutritional Yeast: A cheesy flavor, great for vegans. Use in pasta or on popcorn.", "Cashew Cheese: A creamy, vegan cheese. Great for spreads and dips.", "Olive Oil (for pizza): Drizzle olive oil as a topping instead of cheese for a healthier option."]),
        ("Meat", ["Tofu: A great protein-packed substitute, use in stir-fries or grilled dishes.", "Tempeh: A fermented soy product, great for tacos, sandwiches, or salads.", "Mushrooms: A meaty texture, great for burgers, stir-fries, or as a main dish.", "Nuts: Almonds, walnuts, or cashews can add protein and texture to meals instead of meat."]),
        ("Salt", ["Soy Sauce / Tamari: Use for savory depth in cooked dishes, but high in sodium (use in moderation)", "Miso Paste: Adds saltiness plus umami, especially in soups or marinades.", "Herbs & Spices: Add flavor with no sodium — try garlic powder, smoked paprika, etc.", "Note: For some baking recipes salt is a crucial ingredient that cannot easily be replicated or replaced."]),
        ("Butter", ["Margarine: A common butter replacement in baking and cooking.", "Vegetable or Seed Oils (like canola or sunflower oil): Use 3/4 cup oil for every 1 cup butter.", "Coconut Oil: Use in baking 1:1 for butter, adds slight coconut flavor."]),
        ("Flour", ["Rice Flour: A gluten-free alternative, best for light baked goods.", "Oat Flour: Sub 1:1 for wheat flour, but check labels for gluten-free certification due to possible cross-contamination.", "Almond Flour: Good for gluten-free baking but requires moisture adjustments."]),
    ]

    var body: some View {
        
        ZStack {
            
            themeManager.selectedTheme.backgroundView

            ScrollView {
                VStack(spacing: 20) {
                    Text("Common Ingredient Substitutions")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                        .multilineTextAlignment(.center)

                    Text("Tap on an ingredient to see common substitutes and how to use them in your cooking. Find new alternatives to fit your dietary needs!")
                        .font(.body)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)

                    Text("Disclaimer: Substitutions may not work for all recipes or dietary needs. Always adjust based on your specific use case.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 10)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(ingredients.filter { $0.0 != selectedCard }, id: \.0) { ingredientData in
                            flippableIngredientCard(ingredient: ingredientData.0, substitutes: ingredientData.1)
                                .zIndex(selectedCard == ingredientData.0 ? 1 : 0)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .padding()
            }
            .overlay(
                selectedCardOverlay
            )
        }
    }

    @ViewBuilder
    private var selectedCardOverlay: some View {
        if let selected = selectedCard,
           let data = ingredients.first(where: { $0.0 == selected }) {
            GeometryReader { geo in
                ZStack(alignment: .topTrailing) {
                    flippableIngredientCard(ingredient: data.0, substitutes: data.1)
                        .frame(width: geo.size.width - 32, height: 360)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedCard = nil
                            }
                        }
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .zIndex(10)

                    Button(action: {
                        withAnimation {
                            selectedCard = nil
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .background(Color.white.clipShape(Circle()))
                            .shadow(radius: 2)
                    }
                    .padding()
                    .offset(x: -20, y: 20)
                }
            }
            .background(Color.black.opacity(0.2).ignoresSafeArea().onTapGesture {
                withAnimation {
                    selectedCard = nil
                }
            })
            .transition(.opacity)
        }
    }

    private func flippableIngredientCard(ingredient: String, substitutes: [String]) -> some View {
        let isSelected = selectedCard == ingredient
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth: CGFloat = isSelected ? screenWidth - 32 : (screenWidth / 2) - 40
        let cardHeight: CGFloat = isSelected ? 360 : 130

        return VStack {
            ZStack {
                if isSelected {
                    backOfIngredientCard(ingredient: ingredient, substitutes: substitutes)
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

    private func backOfIngredientCard(ingredient: String, substitutes: [String]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(ingredient) Substitutes:")
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
                    .padding(.leading, 4)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.customPink)
        .foregroundColor(.black)
        .cornerRadius(12)
    }
}

struct IngredientSubView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientSubView()
    }
}
