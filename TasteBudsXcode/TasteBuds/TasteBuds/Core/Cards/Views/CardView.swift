import SwiftUI

struct CardView: View {
    //@ObservedObject var recipeFetcher: RecipeFetcher
    @ObservedObject var viewModel: CardsViewModel
    var body: some View {
        VStack {
            if let recipe = viewModel.currentRecipe {
                VStack {
                    // Display the recipe image
                    if let recipeImage = recipe.recipeImage,
                       let url = URL(string: recipeImage) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            Image("placeholder")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    } else {
                        Image("placeholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // Display the recipe name and description
                    Text(recipe.name)
                        .font(.title)
                        .bold()
                        .padding(.top, 10)
                    Text(recipe.description)
                        .font(.body)
                        .padding(.top, 5)

                    // Display the recipe ingredients and steps
                    Text("Ingredients:")
                        .font(.headline)
                        .padding(.top, 10)
                    Text(recipe.ingredients)

                    Text("Steps:")
                        .font(.headline)
                        .padding(.top, 10)
                    Text(recipe.steps)
                }
                .padding()
            } else {
                // Display a message when no recipe is fetched
                Text("No recipe available")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRecipe()
            }
        }
    }
}
