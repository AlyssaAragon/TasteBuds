// Hannah, Alyssa, Alicia
import SwiftUI

struct CardView: View {
    //favorites
    @EnvironmentObject var favoritesManager: FavoritesManager
    //theme
    @EnvironmentObject var themeManager: ThemeManager
    
    //recipe fetchers
    @State private var currentRecipe: FetchedRecipe? = nil
    @State private var nextRecipe: FetchedRecipe? = nil
    private let recipeFetcher = RecipeFetcher()

    //card swipe animations
    @State private var offset = CGSize.zero
    @State private var dragAmount = CGSize.zero
    @State private var isSwiped = false
    @State private var isFlipped = false
    @State private var canSwipe = true

    
    //dietary filter
    @State private var selectedFilters: [String] = []
    @State private var showFilterMenu = false
    
    //prevents infinite refresh glitch when editing
    @State private var isFirstLoad = true

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    themeManager.selectedTheme.backgroundView

                    VStack {
                        // Logo with dynamic height
                        Image("white_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.45)
                            .padding(.top, geometry.size.height * -0.06)
                            .padding(.bottom, geometry.size.height * 0.06)
                                
                        if let recipe = currentRecipe {
                            flippableRecipeCard(recipe: recipe, geometry: geometry)
                        } else {
                            Text("Fetching recipes...")
                                .font(.headline)
//                                .foregroundStyle(themeManager.selectedTheme.textColor)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    // MARK: - Swipe Buttons
                    HStack {
                        Button(action: {
                            self.swipeLeft()
                        }) {
                            Circle()
                                .fill(Color(hex: 0x5bc3eb))
                                .shadow(radius: 10)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                                .overlay(
                                    Image(systemName: "hand.thumbsdown.fill")
                                        .foregroundStyle(.white)
                                        .font(.title)
                                )
                        }


                        Spacer()

                        Button(action: {
                            self.swipeRight()
                        }) {
                            Circle()
                                .fill(Color(hex: 0xda2c38))
                                .shadow(radius: 10)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.white)
                                        .font(.title)
                                )
                        }

                    }
                    .frame(width: geometry.size.width * 0.75)
                    .padding(.top, geometry.size.height * 0.68)
                }
                .onAppear {
                    if isFirstLoad {
                        isFirstLoad = false
                        Task {
                            await fetchRecipe()
                            await recipeFetcher.testImageFetching()

                        }
                    }
                }

                //MARK: - Dietary Filter
                .navigationBarItems(trailing: Button(action: {
                    showFilterMenu.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.primary)
                })
                .sheet(isPresented: $showFilterMenu) {
                    ZStack {
                        themeManager.selectedTheme.backgroundView
                        VStack {
                            Button("Close") {
                                showFilterMenu.toggle()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            Spacer()
                            
                            Text("Filter")
                                .font(.title)
                                .bold()
                            Spacer()
                            
                            Toggle("Drinks", isOn: Binding(
                                get: { selectedFilters.contains("drink") },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFilters.append("drink")
                                    } else {
                                        selectedFilters.removeAll { $0 == "drink" }
                                    }
                                })
                            )
                            .font(.title3)
                            .padding()
                            
                            Text("Dietary Preferences")
                                .font(.title)
                                .bold()
                            Spacer()
                            
                            Toggle("Vegetarian", isOn: Binding(
                                get: { selectedFilters.contains("vegetarian") },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFilters.append("vegetarian")
                                    } else {
                                        selectedFilters.removeAll { $0 == "vegetarian" }
                                    }
                                })
                            )
                            .font(.title3)
                            .padding()
                            
                            Toggle("Gluten-Free", isOn: Binding(
                                get: { selectedFilters.contains("gluten-free") },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFilters.append("gluten-free")
                                    } else {
                                        selectedFilters.removeAll { $0 == "gluten-free" }
                                    }
                                })
                            )
                            .font(.title3)
                            .padding()
                            
                            Toggle("Low-Carb", isOn: Binding(
                                get: { selectedFilters.contains("low-carb") },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFilters.append("low-carb")
                                    } else {
                                        selectedFilters.removeAll { $0 == "low-carb" }
                                    }
                                })
                            )
                            .font(.title3)
                            .padding()
                            
                            Toggle("Low-Calorie", isOn: Binding(
                                get: { selectedFilters.contains("low-calorie") },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFilters.append("low-calorie")
                                    } else {
                                        selectedFilters.removeAll { $0 == "low-calorie" }
                                    }
                                })
                            )
                            .font(.title3)
                            .padding()
                            
                            Toggle("Low-Sodium", isOn: Binding(
                                get: { selectedFilters.contains("low-sodium") },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFilters.append("low-sodium")
                                    } else {
                                        selectedFilters.removeAll { $0 == "low-sodium" }
                                    }
                                })
                            )
                            .font(.title3)
                            .padding()
                            
                            Spacer()
                            
                            Button("See filtered recipes") {
                                Task {
                                    await fetchFilteredRecipes()
                                    showFilterMenu.toggle()
                                }
                            }
                            .padding()
                            .font(.title3)
                            .background(Color(UIColor.systemBackground))
                            .foregroundStyle(.primary)
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
        }
    }

    // MARK: - Flippable Recipe Card
        private func flippableRecipeCard(recipe: FetchedRecipe, geometry: GeometryProxy) -> some View {
            ZStack(alignment: .bottom) {
                ZStack {
                    frontOfCard(recipe: recipe, geometry: geometry)
                        .opacity(isFlipped ? 0.0 : 1.0)
                    backOfCard(recipe: recipe, geometry: geometry)
                        .opacity(isFlipped ? 1.0 : 0.0)
                }
                .animation(.easeInOut, value: isFlipped)
                .onTapGesture {
                    withAnimation {
                        isFlipped.toggle()
                    }
                }
                .offset(x: dragAmount.width, y: dragAmount.height - 40)
                .rotationEffect(.degrees(Double(dragAmount.width / 20)))
                .scaleEffect(dragAmount.width == 0 ? 1.0 : 0.95)
                .animation(.interactiveSpring(), value: dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.spring()) {
                                self.dragAmount = value.translation
                            }
                        }
                        .onEnded { value in
                            let horizontalSwipe = value.predictedEndTranslation.width
                            let swipeVelocity = horizontalSwipe / value.time.timeIntervalSinceNow.magnitude

                            if abs(horizontalSwipe) > 150 || abs(swipeVelocity) > 500 {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    self.dragAmount = CGSize(width: horizontalSwipe > 0 ? 1000 : -1000, height: 0)
                                }
                                Task {
                                    if horizontalSwipe > 0 {
                                        swipeRight()
                                    } else {
                                        swipeLeft()
                                    }
                                    // ✅ Reset to front after swipe
                                    withAnimation {
                                        self.isFlipped = false
                                        self.dragAmount = .zero
                                    }
                                }
                            } else {
                                withAnimation(.spring()) {
                                    self.dragAmount = .zero
                                }
                            }
                        }
                )
            }
        }

    // MARK: - Front of Card
    private func frontOfCard(recipe: FetchedRecipe, geometry: GeometryProxy) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(recipe.name)
                .font(.title.bold())
                .padding()
                .lineLimit(3)
                .minimumScaleFactor(0.1)
//                .foregroundColor(themeManager.selectedTheme.textColor)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
            
            //dietary icons
            let dietaryIcons: [String: (icon: String, color: Color)] = [
                "vegetarian": ("leaf.circle.fill", .green),
                "gluten-free": ("tortoise.circle.fill", .orange),
                "low-sodium": ("heart.circle.fill", .red)
            ]
            
            HStack(spacing: 10) { // Adjust spacing as needed
                ForEach(selectedFilters, id: \.self) { filter in
                    if let iconData = dietaryIcons[filter] {
                        Image(systemName: iconData.icon)
                            .resizable()         // Allows resizing
                            .scaledToFill()       // Maintains aspect ratio
                            .frame(width: 50, height: 50) // Adjust size as needed
                            .foregroundColor(iconData.color) // Apply custom color
                    }
                }
            }
            .padding()


            if let url = recipe.imageUrl {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.45)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                placeholder: {
                    Image("placeholder")
                        .resizable()
                        .scaledToFit()
//                        .frame(width: 350, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 350, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
            
            Image(systemName: "ellipsis")
                .font(.title)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.85)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
                .opacity(themeManager.selectedTheme == .highContrast ? 1.0 : 0.5)
        )
    }

    // MARK: - Back of Card
    private func backOfCard(recipe: FetchedRecipe, geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Ingredients")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                let cleanedIngredients = recipe.ingredients
                    .trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
                    .components(separatedBy: "', '")
                    .map { $0.replacingOccurrences(of: "'", with: "").trimmingCharacters(in: .whitespacesAndNewlines) }

                ForEach(cleanedIngredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
//                        .foregroundStyle(themeManager.selectedTheme.textColor)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                Text("Instructions")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(recipe.instructions)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 30)
                
                Spacer(minLength: 30)
                
                NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                    Text("View Full Recipe")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                }
                Spacer(minLength: 30)
                
                Image(systemName: "ellipsis")
                    .font(.title)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .padding()
        }
        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.85)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
        )
    }


    private func fetchFilteredRecipes() async {
        await recipeFetcher.fetchFilteredRecipes(tags: selectedFilters)
        if let fetchedRecipe = recipeFetcher.currentRecipe {
            self.currentRecipe = fetchedRecipe
        }
    }

    private func fetchRecipe() async {
        await recipeFetcher.fetchRecipe()
        if let fetchedRecipe = recipeFetcher.currentRecipe {
            self.currentRecipe = fetchedRecipe
        } else {
            self.currentRecipe = nil
        }
    }

    private func fetchNextRecipe() async {
        self.isSwiped = false
        self.dragAmount = .zero
        self.isFlipped = false
        await fetchRecipe()
    }
    
    private func delaySwipeCooldown() async {
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        canSwipe = true
    }

    private func swipeLeft() {
        guard canSwipe else { return }
        canSwipe = false
        print("Swiped left")

        Task {
            await fetchNextRecipe()
            await delaySwipeCooldown()
        }
    }

    private func swipeRight() {
        guard canSwipe else { return }
        canSwipe = false
        print("Swiped right")

        if let currentRecipe = currentRecipe {
            favoritesManager.addFavorite(currentRecipe)
        }

        Task {
            await fetchNextRecipe()
            await delaySwipeCooldown()
        }
    }

}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
    }
}
