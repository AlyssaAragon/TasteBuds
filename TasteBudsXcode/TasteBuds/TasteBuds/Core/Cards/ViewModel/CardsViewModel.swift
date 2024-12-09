import Foundation

class CardsViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var buttonSwipeAction: SwipeAction? = nil

    private let recipeFetcher: RecipeFetcher
    
    init(recipeFetcher: RecipeFetcher) {
        self.recipeFetcher = recipeFetcher
        Task {
            await fetchRecipe()
        }
    }

    //Fetch a single recipe instead
    func fetchRecipe() async {
        await recipeFetcher.fetchRecipe() //fetch one recipe
        
        if let fetchedRecipe = recipeFetcher.currentRecipe {
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
        removeCard()
    }

    func swipeLeft() {
        removeCard()
    }
}
