// Alyssa Aragon
// FavoritesView.swift
// TasteBuds


import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isGalleryView: Bool = false
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
            .navigationTitle("Favorites")
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
        }
        .padding()
    }
    
    private func emptyStateView() -> some View {
        Text("No favorite recipes yet.")
            .font(.headline)
            .foregroundColor(themeManager.selectedTheme.textColor)
            .padding()
    }
    
    private func galleryView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(sortedRecipes, id: \ .id) { recipe in
                    galleryCard(recipe: recipe)
                }
            }
        }
    }
    
    private func galleryCard(recipe: FetchedRecipe) -> some View {
        VStack {
            recipeTitle(recipe.name)
            recipeImage(recipe.imageName)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.25)))
        .onTapGesture {
            // Navigate to Recipe Detail
        }
        .onLongPressGesture {
            selectedRecipe = recipe
            showDeleteConfirmation = true
        }
    }
    
    private func recipeTitle(_ name: String) -> some View {
        Text(name)
            .font(.headline)
            .padding(5)
            .background(Color.white.opacity(0.7))
    }
    
    private func recipeImage(_ imageName: String?) -> some View {
        Image(imageName ?? "placeholder")
            .resizable()
            .scaledToFit()
            .frame(height: 150)
            .cornerRadius(10)
    }
    
    private func listView() -> some View {
        List {
            ForEach(sortedRecipes, id: \ .id) { recipe in
                NavigationLink(destination: Text("Recipe Detail View")) {
                    Text(recipe.name)
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
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
    }
}
