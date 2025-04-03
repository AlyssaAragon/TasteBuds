// Alyssa Aragon
// FavoritesView.swift
// TasteBuds


import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isEditing = false
    @State private var selectedRecipes: Set<FetchedRecipe> = []
    @State private var isGalleryView: Bool = true
    @State private var sortOrder: SortOrder = .newest
    @State private var showDeleteConfirmation = false
    @State private var selectedRecipe: FetchedRecipe?
    
    enum SortOrder {
        case newest, oldest, alphabetical
    }
    
    var sortedRecipes: [FetchedRecipe] {
        switch sortOrder {
        case .newest:
            return favoritesManager.favoriteRecipes.sorted(by: { $0.id > $1.id })
        case .oldest:
            return favoritesManager.favoriteRecipes.sorted(by: { $0.id < $1.id })
        case .alphabetical:
            return favoritesManager.favoriteRecipes.sorted(by: { $0.name < $1.name })
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.selectedTheme.backgroundView
                VStack {
                    headerView()
                    
                    if favoritesManager.favoriteRecipes.isEmpty {
                        emptyStateView()
                    } else {
                        if isGalleryView {
                            galleryView()
                        } else {
                            listView()
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("My Favorites")
            .onAppear {
                favoritesManager.fetchUserFavorites()
            }


            
            
            
            //MARK: - delete multiple recipes
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Done" : "Select") {
                        isEditing.toggle()
                        if !isEditing { selectedRecipes.removeAll() }
                    }
                }
            }
            .alert("Delete Selected Recipes?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    favoritesManager.removeMultipleFavorites(Array(selectedRecipes))
                    selectedRecipes.removeAll()
                }
            } message: {
                Text("Are you sure you want to remove these recipes from favorites?")
            }
            
            // delete individual recipe
            .alert("Delete Recipe?", isPresented: $showDeleteConfirmation, actions: {
                Button("Delete", role: .destructive) {
                    if let recipe = selectedRecipe {
                        favoritesManager.removeFavorite(recipe)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("Are you sure you want to remove this recipe from favorites?")
            })
        }
    }
    
    private func headerView() -> some View {
        HStack {
            Picker("Sort by", selection: $sortOrder) {
                Text("Newest").tag(SortOrder.newest)
                Text("Oldest").tag(SortOrder.oldest)
                Text("A-Z").tag(SortOrder.alphabetical)
            }
            .pickerStyle(MenuPickerStyle())
            
            Spacer()
            
            Button(action: {
                isGalleryView.toggle()
            }) {
                Image(systemName: isGalleryView ? "list.bullet" : "square.grid.2x2")
                    .foregroundColor(.blue)
            }
            
            if isEditing {
                Button("Delete") {
                    showDeleteConfirmation = true
                }
                .disabled(selectedRecipes.isEmpty)
                .foregroundColor(selectedRecipes.isEmpty ? .gray : .red)
            }
        }
        .padding()
    }
    
    private func emptyStateView() -> some View {
        Text("No favorite recipes yet.")
            .font(.headline)
            .foregroundColor(themeManager.selectedTheme.textColor)
            .padding()
    }
    
    
    
    
    
    //MARK: - Gallery View
    private func galleryView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(sortedRecipes, id: \ .id) { recipe in
                    VStack {
                        if isEditing {
                            Image(systemName: selectedRecipes.contains(recipe) ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    toggleSelection(for: recipe)
                                }
                        }
                        galleryCard(recipe: recipe)
                    }
                    .padding(.bottom, -20)
                    .onLongPressGesture {
                        if !isEditing {
                            selectedRecipes = [recipe]
                            showDeleteConfirmation = true
                        }
                    }
                }
            }
            .padding(.bottom, 50)
        }
    }
    
    private func galleryCard(recipe: FetchedRecipe) -> some View {
        NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
            VStack (alignment: .center, spacing: 5) {
                recipeTitle(recipe.name)
                    .padding()
                    .lineLimit(3)
                    .minimumScaleFactor(0.1)
                if let url = recipe.imageUrl {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 0,
                                    bottomLeadingRadius: 10,
                                    bottomTrailingRadius: 10,
                                    topTrailingRadius: 0
                                )
                            )
//                            .padding(.bottom, 10)
                        
                    }
                    placeholder: {
//                        Image("placeholder")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 100)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else {
//                    Image("placeholder")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 100)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(themeManager.selectedTheme == .highContrast ? 1.0 : 0.5)).frame(width: 170))
        }
        .padding(.bottom, 50)
    }
    
    private func recipeTitle(_ name: String) -> some View {
        Text(name)
            .font(.headline)
            .foregroundStyle(.black)
//            .background(Color.white.opacity(0.7))
    }
    
    //for placeholder image
    private func recipeImage(_ imageName: String?) -> some View {
        Image(imageName ?? "placeholder")
            .resizable()
            .scaledToFit()
            .frame(height: 150)
            .cornerRadius(10)
    }
    
    
    
    
    
    //MARK: - List View
    private func listView() -> some View {
        List {
            ForEach(sortedRecipes, id: \.id) { recipe in
                HStack {
                    if isEditing {
                        Image(systemName: selectedRecipes.contains(recipe) ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                toggleSelection(for: recipe)
                            }
                    }
                    NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                        Text(recipe.name)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        favoritesManager.removeFavorite(recipe)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.bottom, 50)
    }
    
    private func toggleSelection(for recipe: FetchedRecipe) {
        if selectedRecipes.contains(recipe) {
            selectedRecipes.remove(recipe)
        } else {
            selectedRecipes.insert(recipe)
        }
    }
}


struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
    }
}

