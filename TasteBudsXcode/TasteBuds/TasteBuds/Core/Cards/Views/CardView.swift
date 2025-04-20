// Hannah Haggerty and Alyssa
import SwiftUI
enum Category: String, CaseIterable, Identifiable {
    case meal, drink, dessert

    var id: String { self.rawValue }

    var label: String {
        switch self {
        case .meal: return "Food"
        case .drink: return "Drink"
        case .dessert: return "Dessert"
        }
    }
}

struct CardView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager

    @State private var currentRecipe: FetchedRecipe? = nil
    private let recipeFetcher = RecipeFetcher()

    @State private var offset = CGSize.zero
    @State private var dragAmount = CGSize.zero
    @State private var isSwiped = false
    @State private var isFlipped = false

    @State private var selectedFilters: [String] = []
    @State private var selectedCategory: String = ""
    @State private var showFilterMenu = false
    @State private var isFirstLoad = true

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    themeManager.selectedTheme.backgroundView

                    VStack {
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
                                .foregroundColor(themeManager.selectedTheme.textColor)
                                .padding()
                        }

                        Spacer()
                    }

                    HStack {
                        Button(action: { swipeLeft() }) {
                            Circle()
                                .fill(Color(hex: 0x5bc3eb))
                                .shadow(radius: 10)
                                .frame(width: 80, height: 80)
                                .overlay(Image(systemName: "hand.thumbsdown.fill").foregroundColor(.white).font(.title))
                        }

                        Spacer()

                        Button(action: { swipeRight() }) {
                            Circle()
                                .fill(Color(hex: 0xda2c38))
                                .shadow(radius: 10)
                                .frame(width: 80, height: 80)
                                .overlay(Image(systemName: "heart.fill").foregroundColor(.white).font(.title))
                        }
                    }
                    .frame(width: geometry.size.width * 0.75)
                    .padding(.top, geometry.size.height * 0.7)
                }
                .onAppear {
                    if isFirstLoad {
                        isFirstLoad = false
                        if let token = AuthService.shared.getAccessToken() {
                            Task {
                                let savedDiets = await recipeFetcher.fetchUserDietPreferences(token: token)
                                self.selectedFilters = savedDiets
                                await fetchRecipe()
                            }
                        } else {
                            Task { await fetchRecipe() }
                        }
                    }
                }
                .navigationBarItems(trailing: Button(action: { showFilterMenu.toggle() }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                })
                .sheet(isPresented: $showFilterMenu) {
                    ZStack {
                        themeManager.selectedTheme.backgroundView
                        VStack {
                            Button("Close") { showFilterMenu.toggle() }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()

                            Spacer()

                            Text("Category")
                                .font(.title)
                                .bold()

                            ForEach(Category.allCases) { category in
                                Toggle(category.label, isOn: Binding(
                                    get: { selectedCategory == category.rawValue },
                                    set: { isSelected in
                                        selectedCategory = isSelected ? category.rawValue : ""
                                    }
                                ))
                                .padding(.horizontal)
                            }


                            Text("Dietary Preferences")
                                .font(.title)
                                .bold()

                            ForEach(Diet.allCases, id: \.rawValue) { diet in
                                Toggle(diet.label, isOn: Binding(
                                    get: { selectedFilters.contains(diet.rawValue) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedFilters.append(diet.rawValue)
                                        } else {
                                            selectedFilters.removeAll { $0 == diet.rawValue }
                                        }
                                    }
                                ))
                                .padding()
                            }

                            Spacer()

                            Button("See filtered recipes") {
                                Task {
                                    await fetchRecipe()
                                    showFilterMenu.toggle()
                                }
                            }
                            .padding()
                            .font(.title3)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
        }
    }

    private func fetchRecipe() async {
        await recipeFetcher.fetchCombinedRecipe(
            category: selectedCategory.isEmpty ? nil : selectedCategory,
            diets: selectedFilters
        )
        self.currentRecipe = recipeFetcher.currentRecipe
    }

    private func swipeLeft() {
        Task {
            await fetchRecipe()
            isSwiped = false
            dragAmount = .zero
            isFlipped = false
        }
    }

    private func swipeRight() {
        if let recipe = currentRecipe {
            favoritesManager.addFavorite(recipe)
        }
        swipeLeft()
    }

    private func flippableRecipeCard(recipe: FetchedRecipe, geometry: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            ZStack {
                frontOfCard(recipe: recipe, geometry: geometry).opacity(isFlipped ? 0.0 : 1.0)
                backOfCard(recipe: recipe, geometry: geometry).opacity(isFlipped ? 1.0 : 0.0)
            }
            .animation(.easeInOut, value: isFlipped)
            .onTapGesture {
                withAnimation { isFlipped.toggle() }
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
                        if abs(horizontalSwipe) > 150 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                self.dragAmount = CGSize(width: horizontalSwipe > 0 ? 1000 : -1000, height: 0)
                            }
                            swipeLeft()
                        } else {
                            withAnimation(.spring()) {
                                self.dragAmount = .zero
                            }
                        }
                    }
            )
        }
    }

    private func frontOfCard(recipe: FetchedRecipe, geometry: GeometryProxy) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(recipe.name)
                .font(.title.bold())
                .padding()
                .lineLimit(3)
                .minimumScaleFactor(0.1)
                .foregroundColor(themeManager.selectedTheme.textColor)
                .multilineTextAlignment(.center)

            let dietaryIcons: [String: (icon: String, color: Color)] = [
                "vegetarian": ("leaf.circle.fill", .green),
                "gluten-free": ("tortoise.circle.fill", .orange),
                "low-sodium": ("heart.circle.fill", .red)
            ]

            HStack(spacing: 10) {
                ForEach(selectedFilters, id: \.self) { filter in
                    if let iconData = dietaryIcons[filter] {
                        Image(systemName: iconData.icon)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .foregroundColor(iconData.color)
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
                } placeholder: {
                    Image("placeholder")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Spacer()

            Image(systemName: "ellipsis")
                .font(.title)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.85)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .opacity(themeManager.selectedTheme == .highContrast ? 1.0 : 0.5)
        )
    }

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
                        .foregroundColor(themeManager.selectedTheme.textColor)
                }

                Spacer()

                Text("Instructions")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(recipe.instructions)
                    .foregroundColor(themeManager.selectedTheme.textColor)
                    .padding(.bottom, 30)

                NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                    Text("View Full Recipe")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer(minLength: 30)

                Image(systemName: "ellipsis")
                    .font(.title)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.85)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
    }
}
