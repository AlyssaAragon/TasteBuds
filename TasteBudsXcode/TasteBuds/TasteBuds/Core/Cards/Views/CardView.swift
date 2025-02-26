// Hannah, Alyssa, Alicia
import SwiftUI



struct CardView: View {
    @State private var currentRecipe: FetchedRecipe? = nil
    @State private var nextRecipe: FetchedRecipe? = nil
    private let recipeFetcher = RecipeFetcher()
    
    @State private var offset = CGSize.zero
    @State private var dragAmount = CGSize.zero
    @State private var isSwiped = false
    
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    @State private var selectedFilters: [String] = []
    @State private var showFilterMenu = false
    
    var body: some View {
        NavigationView {
            ZStack{
                
                Color.clear.customGradientBackground()
                
                VStack {
                    Image("white_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 290)
                        .padding(.top, 290)

                    //Spacer().frame(height: -80)
                    
// Recipe card display
// We need to add flipping the recipe for more information
                    if let recipe = currentRecipe {
                        VStack {
                            if let recipeImage = recipe.imageName,
                               let url = URL(string: recipeImage) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 280)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                placeholder: {
                                    Image("placeholder")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 350)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            else{
                                Image("placeholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 350, height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Text(recipe.name)
                                .font(.title.bold())
                                .padding()
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                        
                        .padding(.top, 30)
                        
                        .frame(width: 380, height: 500)
                        
                        
                        
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                        .offset(x: dragAmount.width, y: dragAmount.height - 70)
                        .gesture(DragGesture()
                            .onChanged { value in
                                self.dragAmount = value.translation
                            }
                                 
                            .onEnded { value in
                                if abs(value.translation.width) > 150 {
                                    self.isSwiped = true
                                    
                                    if value.translation.width > 0 {
                                
                                        self.swipeRight()
                                    } else {
            
                                        self.swipeLeft()
                                    }
                                } else {
                                    self.dragAmount = .zero
                                }
                            })
                    } else {
                        Text("No recipe available")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    
                    //Spacer()
                    
//  swipe buttons
                    HStack {
                        Button(action: {
                            self.swipeLeft()
                        }) {
                            Circle()
                                .fill(Color(hex: 0x5bc3eb))
                                .shadow(radius: 65)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "hand.thumbsdown.fill")
                                        .foregroundColor(Color.white)
                                        .font(.title)
                                )
                        }
                        .padding(.leading, 40)
                        
                        Spacer()
                        
                        Button(action: {
                            self.swipeRight()
                        }) {
                            Circle()
                                .fill(Color(hex: 0xda2c38))
                                .shadow(radius: 65)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color.white)
                                        .font(.title)
                                )
                        }
                        .padding(.trailing, 40)
                    }
                    .padding(.bottom, 480)
                }
            }
            
            .onAppear {
                Task {
                    await fetchRecipe()
                }
            }

//  Dietary filters button
            
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
                    
                    // Button to display filtered recipes
                    Button("See filtered recipes") {
                        print("Filtered recipes button tapped")
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
        }
    }

    private func fetchNextRecipe() async {
        self.isSwiped = false
        self.dragAmount = .zero

        await recipeFetcher.fetchRecipe()
        if let nextFetchedRecipe = recipeFetcher.currentRecipe {
            self.currentRecipe = nextFetchedRecipe
        }
    }

    private func swipeLeft() {
        print("Swiped left")
        Task {
            await fetchNextRecipe()
        }
    }

    private func swipeRight() {
        print("Swiped right")
        if let currentRecipe = currentRecipe {
            favoritesManager.addFavorite(currentRecipe)
        }
        Task {
            await fetchNextRecipe()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .environmentObject(FavoritesManager())
    }
}
