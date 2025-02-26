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

                        // Recipe card and swipe buttons or error message
                        if let recipe = currentRecipe {
                            ZStack(alignment: .bottom) {
                                // Recipe Card
                                VStack(alignment: .leading, spacing: 10) {
                                    // Title on top
                                    Text(recipe.name)
                                        .font(.title.bold())
                                        .padding()
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(themeManager.selectedTheme.textColor)

                                    // Recipe Image
                                    if let recipeImage = recipe.imageName,
                                       let url = URL(string: recipeImage) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width * 0.8)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        } placeholder: {
                                            Image("placeholder")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width * 0.8)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    } else {
                                        Image("placeholder")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width * 0.8)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .padding()
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.8)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .opacity(themeManager.selectedTheme == .highContrast ? 1.0 : 0.5) // ✅ Adjust opacity based on theme
                                )
                                
                                //animation
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
                                                }
                                            } else {
                                                withAnimation(.spring()) {
                                                    self.dragAmount = .zero
                                                }
                                            }
                                        }
                                )

                                // Swipe Buttons Overlay
                                HStack {
                                    Button(action: {
                                        self.swipeLeft()
                                    }) {
                                        Circle()
                                            .fill(Color(hex: 0x5bc3eb))
                                            .shadow(radius: 10)
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Image(systemName: "hand.thumbsdown.fill")
                                                    .foregroundColor(Color.white)
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
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Image(systemName: "heart.fill")
                                                    .foregroundColor(Color.white)
                                                    .font(.title)
                                            )
                                    }

                                }
                                .frame(width: geometry.size.width * 0.95)
                            }
                        } else {
                            // Message when recipe isn't fetching
                            Text("Fetching recipes...")
                                .font(.headline)
                                .foregroundColor(themeManager.selectedTheme.textColor)
                                .multilineTextAlignment(.center)
                                .padding()
                        }

                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .onAppear {
                    if isFirstLoad {
                        isFirstLoad = false
                        Task {
                            await fetchRecipe()
                        }
                    }
                }

                // dietary filter
                .navigationBarItems(trailing: Button(action: {
                    showFilterMenu.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.white)
                })
                .sheet(isPresented: $showFilterMenu) {
                    VStack {
                        Text("Filter Options")
                            .font(.title)
                            .bold()
                        Toggle("Low-Carb", isOn: Binding(
                            get: { selectedFilters.contains("low-carb") },
                            set: { isSelected in
                                if isSelected {
                                    selectedFilters.append("low-carb")
                                } else {
                                    selectedFilters.removeAll { $0 == "low-carb" }
                                }
                            })
                        ).padding(.horizontal)

                        Toggle("Low-Calorie", isOn: Binding(
                            get: { selectedFilters.contains("low-calorie") },
                            set: { isSelected in
                                if isSelected {
                                    selectedFilters.append("low-calorie")
                                } else {
                                    selectedFilters.removeAll { $0 == "low-calorie" }
                                }
                            })
                        ).padding(.horizontal)

                        Toggle("Low-Sodium", isOn: Binding(
                            get: { selectedFilters.contains("low-sodium") },
                            set: { isSelected in
                                if isSelected {
                                    selectedFilters.append("low-sodium")
                                } else {
                                    selectedFilters.removeAll { $0 == "low-sodium" }
                                }
                            })
                        ).padding(.horizontal)

                        Toggle("Vegetarian", isOn: Binding(
                            get: { selectedFilters.contains("vegetarian") },
                            set: { isSelected in
                                if isSelected {
                                    selectedFilters.append("vegetarian")
                                } else {
                                    selectedFilters.removeAll { $0 == "vegetarian" }
                                }
                            })
                        ).padding(.horizontal)

                        Button("Close") {
                            showFilterMenu.toggle()
                        }
                        .padding()

                        Button("See filtered recipes") {
                            Task {
                                await fetchFilteredRecipes()
                                showFilterMenu.toggle()
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                    }
                    .padding()
                }
            }
        }
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
            self.currentRecipe = nil // Explicitly set to nil if fetching fails
        }
    }

    private func fetchNextRecipe() async {
        self.isSwiped = false
        self.dragAmount = .zero
        await fetchRecipe()
    }

    private func swipeLeft() {
        print("Swiped left")
        Task {
            await fetchNextRecipe() // Directly fetch next recipe without relying on isSwiped
        }
    }

    private func swipeRight() {
        print("Swiped right")
        if let currentRecipe = currentRecipe {
            favoritesManager.addFavorite(currentRecipe)
        }
        Task {
            await fetchNextRecipe() // Directly fetch next recipe without relying on isSwiped
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
