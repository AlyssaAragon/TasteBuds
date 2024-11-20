import SwiftUI

struct CardView: View {
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @StateObject private var recipeFetcher = RecipeFetcher()
    var body: some View {
        ZStack(alignment: .bottom) {
            // Display the first recipe if available
            if let recipe = recipeFetcher.recipes.first {
                VStack {
                    HStack {
                        Button(action: {
                            //Hamburger menu
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    .padding(.top)

                    Color.gray //Placeholder for recipe image
                        .scaledToFill()
                        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)

                    RecipeInfoView(recipe: recipe)//Pass the recipe to RecipeInfoView
                        .padding(.horizontal)
                }

                HStack {
                    Button(action: {
                        //Dislike button
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: {
                        //Like button
                    }) {
                        Image(systemName: "heart.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    }
                }
                .padding()
            } else {
                Text("Loading recipes...")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            recipeFetcher.fetchRecipes()
        }
    }
}
