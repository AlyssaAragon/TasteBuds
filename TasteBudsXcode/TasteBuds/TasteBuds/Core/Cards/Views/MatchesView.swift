import SwiftUI

struct MatchesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager

    @State private var isGalleryView: Bool = true
    @State private var sortOrder: FavoritesView.SortOrder = .newest

    var sortedSharedFavorites: [FavoritesManager.SavedRecipeWrapper] {
        switch sortOrder {
        case .newest:
            return favoritesManager.sharedFavorites.sorted(by: { $0.id > $1.id })
        case .oldest:
            return favoritesManager.sharedFavorites.sorted(by: { $0.id < $1.id })
        case .alphabetical:
            return favoritesManager.sharedFavorites.sorted(by: { $0.recipe.name < $1.recipe.name })
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.selectedTheme.backgroundView
                VStack {
                    headerView()

                    if let error = favoritesManager.sharedFavoritesError {
                        Text("It looks like you haven't set up a partner yet. Add your partner to start sharing your favorite recipes and see your mutual matches!")
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if favoritesManager.sharedFavorites.isEmpty {
                        Text("No shared matches found yet. Start liking recipes, and your mutual favorites will appear here!")
                            .multilineTextAlignment(.center)
                            .padding()
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
            .navigationTitle("Our Favorites")
            .onAppear {
                favoritesManager.fetchSharedFavorites()
            }
        }
    }

    private func headerView() -> some View {
        HStack {
            Picker("Sort by", selection: $sortOrder) {
                Text("Newest").tag(FavoritesView.SortOrder.newest)
                Text("Oldest").tag(FavoritesView.SortOrder.oldest)
                Text("A-Z").tag(FavoritesView.SortOrder.alphabetical)
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

    private func galleryView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(sortedSharedFavorites, id: \.id) { wrapper in
                    let recipe = wrapper.recipe

                    NavigationLink(destination: RecipeDetailsView(recipe: recipe).environmentObject(themeManager)) {
                        VStack {
                            Text(recipe.name)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .padding()

                            if let url = recipe.imageUrl {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 170, height: 170)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                        .frame(width: 170, height: 170)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(themeManager.selectedTheme == .highContrast ? 1.0 : 0.5))
                                .frame(width: 170)
                        )
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding(.bottom, 50)
        }
    }

    private func listView() -> some View {
        List {
            ForEach(sortedSharedFavorites, id: \.id) { wrapper in
                NavigationLink(destination: RecipeDetailsView(recipe: wrapper.recipe).environmentObject(themeManager)) {
                    Text(wrapper.recipe.name)
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.bottom, 50)
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
            .environmentObject(FavoritesManager())
            .environmentObject(ThemeManager())
    }
}
