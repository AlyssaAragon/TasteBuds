import SwiftUI

struct FavoritesView: View {
    @State private var selectedTab = 0 // 0 for personal, 1 for shared

    var body: some View {
        NavigationView {
            VStack {
                Picker("Favorites", selection: $selectedTab) {
                    Text("My Favorites").tag(0)
                    Text("Our Favorites").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    UserFavoritesView()
                } else {
                    SharedFavoritesView()
                }

                Spacer()
            }
            .navigationTitle("Favorites")
        }
    }
}

struct UserFavoritesView: View {
    var body: some View {
        VStack {
            Text("Mock Favorite Recipes")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            List {
                NavigationLink(destination: RecipeDetailView(recipeName: "Spaghetti Carbonara", ingredients: "Pasta, Eggs, Bacon, Parmesan", instructions: "Cook pasta. Mix eggs and cheese. Fry bacon. Combine.")) {
                    Text("Spaghetti Carbonara")
                }
                NavigationLink(destination: RecipeDetailView(recipeName: "Chicken Tikka Masala", ingredients: "Chicken, Yogurt, Spices, Tomato Sauce", instructions: "Marinate chicken. Cook with sauce. Serve with rice.")) {
                    Text("Chicken Tikka Masala")
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct SharedFavoritesView: View {
    var body: some View {
        VStack {
            Text("Mock Shared Favorite Recipes")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            List {
                NavigationLink(destination: RecipeDetailView(recipeName: "Pancakes", ingredients: "Flour, Eggs, Milk, Baking Powder", instructions: "Mix ingredients. Cook on skillet. Flip. Serve.")) {
                    Text("Pancakes")
                }
                NavigationLink(destination: RecipeDetailView(recipeName: "Avocado Toast", ingredients: "Bread, Avocado, Salt, Pepper", instructions: "Toast bread. Mash avocado. Spread on toast.")) {
                    Text("Avocado Toast")
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct RecipeDetailView: View {
    let recipeName: String
    let ingredients: String
    let instructions: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(recipeName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Ingredients")
                    .font(.headline)
                    .padding(.horizontal)
                Text(ingredients)
                    .padding(.horizontal)
                
                Text("Instructions")
                    .font(.headline)
                    .padding(.horizontal)
                Text(instructions)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Recipe Details")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
