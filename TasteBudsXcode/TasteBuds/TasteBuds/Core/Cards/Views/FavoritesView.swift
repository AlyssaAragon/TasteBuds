// Alyssa Aragon
// FavoritesView.swift
// TasteBuds


import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.selectedTheme.backgroundView
                
                VStack {
                    Text("Favorites")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.selectedTheme.textColor)
                        .padding()
                    
                    if favoritesManager.favoriteRecipes.isEmpty {
                        Text("No favorite recipes yet.")
                            .font(.headline)
                            .foregroundColor(themeManager.selectedTheme.textColor)
                            .padding()
                    } else {
                        List{
                            ForEach(favoritesManager.favoriteRecipes) { recipe in
                                VStack(alignment: .leading) {
                                    Text(recipe.name)
                                        .font(.headline)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                    }
                    Spacer()
                }
            }
            //.navigationTitle("Favorites")
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
