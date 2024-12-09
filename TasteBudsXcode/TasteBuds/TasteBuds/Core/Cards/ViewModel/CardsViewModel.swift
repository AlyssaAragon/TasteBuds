import Foundation

class CardsViewModel: ObservableObject {
//ObservableObject: This protocol allows this class to be observed by SwiftUI views. When a property marked with @Published changes, SwiftUI updates the UI automatically.
    
    @Published var cardModels = [CardModel]()
    @Published var buttonSwipeAction: SwipeAction? = nil
//    @Published: Marks the property as observable. Changes to this array trigger UI updates.
    
    private let recipeFetcher: RecipeFetcher
//    recipeFetcher: A dependency used to fetch recipes from a backend or database. It's private, so it can only be accessed within this class.
    
    init(recipeFetcher: RecipeFetcher) {
        self.recipeFetcher = recipeFetcher
        Task {
            await fetchRecipe()
//            When the class is initialized, it immediately starts fetching a recipe in an asynchronous task.
        }
    }


    func fetchRecipe() async {
//        Asynchronously fetches a single recipe.
        await recipeFetcher.fetchRecipe()
//        Calls the fetchRecipe method on the RecipeFetcher, which fetches the recipe from the backend.
        
        if let fetchedRecipe = recipeFetcher.currentRecipe {
//            After fetching, retrieves the current recipe from RecipeFetcher.
            DispatchQueue.main.async {
//                Updates the cardModels array on the main thread since UI updates must happen on the main thread.
                self.cardModels = [CardModel(recipe: fetchedRecipe)]
//                Populates the cardModels array with a new CardModel created using the fetched recipe.
            }
        }
    }

    func removeCard() {
//        Removes the top card from the cardModels array.
        guard !cardModels.isEmpty else { return }
        cardModels.removeFirst()
    }
    
//    These methods handle swiping actions (right for like, left for reject).
//    Both call removeCard() to remove the card after a swipe.
    func swipeRight() {
        removeCard()
    }

    func swipeLeft() {
        removeCard()
    }
}

/* ****NOTES and USAGE****
 
 Ali 12.9.24--
 CardsViewModel.swift handles the logic for managing a collection of cards and user interactions.
 If you need to modify how cards are fetched or handled, you only update CardsViewModel.swift.
 CardsViewModel can be expanded or reused for other functionalities, such as integrating with a different data source.
 You can separately test CardsViewModel for managing the card list and business logic.
 
 
 */
