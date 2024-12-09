import SwiftUI

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
