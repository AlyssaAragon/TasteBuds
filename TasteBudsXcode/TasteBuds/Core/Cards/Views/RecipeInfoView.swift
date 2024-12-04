import SwiftUI

struct RecipeInfoView: View {
    // var recipe: FetchedRecipe
    @StateObject private var recipeFetcher = RecipeFetcher()


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(FetchedRecipe.title)
                    .font(.title)
                    .fontWeight(.heavy)
                Text(FetchedRecipe.diets.first?.name ?? "No Diet")
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
            Text(FetchedRecipe.body)//Displays recipe description
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
