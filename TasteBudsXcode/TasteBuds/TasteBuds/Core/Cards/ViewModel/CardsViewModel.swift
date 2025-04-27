// Hannah, Alyssa, Alicia
import Foundation

class CardsViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var buttonSwipeAction: SwipeAction? = nil
    @Published var currentRecipe: FetchedRecipe?

    private let recipeFetcher: RecipeFetcher

    init(recipeFetcher: RecipeFetcher) {
        self.recipeFetcher = recipeFetcher
    }

    @MainActor
    func fetchRecipe(basedOn selectedFilters: [String], category: String?) async {
        await recipeFetcher.fetchCombinedRecipe(category: category, diets: selectedFilters)

        if let fetchedRecipe = recipeFetcher.currentRecipe {
            DispatchQueue.main.async {
                self.currentRecipe = fetchedRecipe
                self.cardModels = [CardModel(recipe: fetchedRecipe)]
            }
        }
    }

    func removeCard() {
        guard !cardModels.isEmpty else { return }
        cardModels.removeFirst()
    }

    func swipeRight() {
        removeCard()
    }

    func swipeLeft() {
        removeCard()
    }
}
