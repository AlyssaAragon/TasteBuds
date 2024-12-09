import SwiftUI

struct RecipeInfoView: View {
    var recipe: FetchedRecipe

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(recipe.title)
                    .font(.title)
                    .fontWeight(.heavy)
                Text(recipe.diets.first?.name ?? "No Diet")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    print("DEBUG: Show recipe here...")
                } label: {
                    Image(systemName: "arrow.up.circle")
                        .fontWeight(.bold)
                        .imageScale(.large)
                }
            }
            Text(recipe.body)
                .font(.subheadline)
                .lineLimit(2)
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    let fetchedRecipe = FetchedRecipe(
            id: 1,
            title: "Sample Title",
            body: "Sample Body",
            createdAt: "2024-12-09",
            time: 30,
            diets: [FetchedDiet(id: 1, name: "Vegan")],
            recipeImage: nil
    )
    return RecipeInfoView(recipe: fetchedRecipe)
}
