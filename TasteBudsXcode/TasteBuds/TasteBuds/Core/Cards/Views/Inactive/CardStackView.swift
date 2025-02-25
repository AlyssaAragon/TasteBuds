/*import SwiftUI
// I removed the dependency in cardview on cardstack view so I think we can delete this file entirely
struct CardStackView: View {
    @StateObject var viewModel = CardsViewModel(recipeFetcher: RecipeFetcher())
    
    var body: some View {
        ZStack {
            ForEach(viewModel.cardModels) { card in
                CardView(viewModel: viewModel, model: card)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRecipe() //updated to fetch a single recipe
            }
        }
    }
}

#Preview {
    CardStackView()
}
*/
