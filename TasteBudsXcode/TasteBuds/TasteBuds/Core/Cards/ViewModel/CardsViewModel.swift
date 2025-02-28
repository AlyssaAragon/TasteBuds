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
    func fetchRecipe() async {
        await recipeFetcher.fetchRecipe() // Fetch the recipe asynchronously
        
        if let fetchedRecipe = recipeFetcher.currentRecipe {
            // Once recipe is fetched it updates the cardModels with a new CardModel using the fetched recipe
            DispatchQueue.main.async {
                self.cardModels = [CardModel(recipe: fetchedRecipe)]
            }
        }
    }

    func removeCard() {
        guard !cardModels.isEmpty else { return }
        cardModels.removeFirst()
    }
    func swipeRight() {
        removeCard() // Handle swipe right action
    }
    func swipeLeft() {
        removeCard() // Handle swipe left action
    }
}
