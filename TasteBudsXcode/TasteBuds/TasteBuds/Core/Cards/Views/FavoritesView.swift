import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isEditing = false
    @State private var selectedRecipes: Set<FavoritesManager.SavedRecipeWrapper> = []
    @State private var selectedWrapper: FavoritesManager.SavedRecipeWrapper?

    @State private var isGalleryView: Bool = true
    @State private var sortOrder: SortOrder = .newest
    @State private var showDeleteConfirmation = false
    
    @AppStorage("isGuestUser") private var isGuestUser = false
    @EnvironmentObject var navigationState: NavigationState
    @State private var showLoginAlert = false

    
    enum SortOrder {
        case newest, oldest, alphabetical
    }
    
    var sortedRecipes: [FavoritesManager.SavedRecipeWrapper] {
        switch sortOrder {
        case .newest:
            return favoritesManager.favoriteRecipes.sorted(by: { $0.id > $1.id })
        case .oldest:
            return favoritesManager.favoriteRecipes.sorted(by: { $0.id < $1.id })
        case .alphabetical:
            return favoritesManager.favoriteRecipes.sorted(by: { $0.recipe.name < $1.recipe.name })
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
                if isGuestUser {
                        showLoginAlert = true
                    }
            }
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
                    if let selected = selectedWrapper {
                        favoritesManager.removeFavorite(selected)
                        selectedWrapper = nil
                    } else {
                        favoritesManager.removeMultipleFavorites(Array(selectedRecipes))
                        selectedRecipes.removeAll()
                    }
                }
            } message: {
                Text("Are you sure you want to remove these recipes from favorites?")
            }
            .alert("Not Logged In", isPresented: $showLoginAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You are not logged in. Go to the Profile page to sign up.")
            }
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
                    .foregroundStyle(Color.accentColor)
            }
            
            if isEditing {
                Button("Delete") {
                    showDeleteConfirmation = true
                }
                .disabled(selectedRecipes.isEmpty)
                .foregroundStyle(selectedRecipes.isEmpty ? .primary : Color.accentColor)
            }
        }
        .padding()
    }

    private func emptyStateView() -> some View {
        Text("No favorite recipes yet.")
            .font(.headline)
            .foregroundStyle(.primary)
            .padding()
    }
    
    //MARK: - Gallery View
    private func galleryView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(sortedRecipes, id: \.id) { wrapper in
                    VStack {
                        if isEditing {
                            Image(systemName: selectedRecipes.contains(wrapper) ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    toggleSelection(for: wrapper)
                                }
                        }
                        galleryCard(wrapper: wrapper)
                    }
                    .padding(.bottom, -20)
                    .onLongPressGesture {
                        if !isEditing {
                            selectedWrapper = wrapper
                            showDeleteConfirmation = true
                        }
                    }
                }
            }
//            .padding(.bottom, 50)
            Spacer(minLength: 60)
        }
    }
    
    //MARK: - Gallery Card

    private func galleryCard(wrapper: FavoritesManager.SavedRecipeWrapper) -> some View {
        let recipe = wrapper.recipe
        return NavigationLink(destination: RecipeDetailsView(recipe: recipe).environmentObject(themeManager)) {
            VStack(alignment: .center, spacing: 5) {
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
                    } placeholder: {
                        Color.gray.opacity(0.1)
                    }
                } else {
//                    Image("placeholder")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 100)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground).opacity(themeManager.selectedTheme == .highContrast ? 1.0 : 0.5)).frame(width: 170))
            .padding()
        }
        .padding(.bottom, 10)
    }
    
    private func recipeTitle(_ name: String) -> some View {
        Text(name)
            .font(.headline)
            .foregroundStyle(Color.primary)
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
            ForEach(sortedRecipes, id: \.id) { wrapper in
                HStack(spacing: 10) {
                    if isEditing {
                        Image(systemName: selectedRecipes.contains(wrapper) ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                toggleSelection(for: wrapper)
                            }
                    }
                    
                    NavigationLink(destination: RecipeDetailsView(recipe: wrapper.recipe).environmentObject(themeManager)) {
                        Text(wrapper.recipe.name)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }
                }
                .padding(.vertical, 8)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        favoritesManager.removeFavorite(wrapper)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            Spacer(minLength: 30)
        }
        .listStyle(PlainListStyle())
    }



    

    private func toggleSelection(for wrapper: FavoritesManager.SavedRecipeWrapper) {
        if selectedRecipes.contains(wrapper) {
            selectedRecipes.remove(wrapper)
        } else {
            selectedRecipes.insert(wrapper)
        }
    }
}
