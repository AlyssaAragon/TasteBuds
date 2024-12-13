// Alyssa Aragon
// FavoritesView.swift
// TasteBuds


import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    var body: some View {
        NavigationView {
            VStack {
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                if favoritesManager.favoriteRecipes.isEmpty {
                    Text("No favorite recipes yet.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    
                    List{
                        ForEach(favoritesManager.favoriteRecipes) { recipe in
                            VStack(alignment: .leading) {
                                Text(recipe.name)
                                    .font(.headline)
                                /*Text(recipe.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)*/
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                }
                Spacer()
            }
            //.navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesManager())
    }
}
