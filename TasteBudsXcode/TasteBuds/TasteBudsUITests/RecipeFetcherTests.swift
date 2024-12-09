import XCTest
@testable import TasteBuds
//test if recipe fetcher is actually fetching
final class RecipeFetcherTests: XCTestCase {

    var recipeFetcher: RecipeFetcher!

    override func setUp() {
        super.setUp()
        recipeFetcher = RecipeFetcher()
    }

    override func tearDown() {
        recipeFetcher = nil
        super.tearDown()
    }

    // Test that fetchRecipe properly fetches a recipe
    func testFetchRecipe() async {
        let expectation = XCTestExpectation(description: "Fetching recipe from API")

        await recipeFetcher.fetchRecipe()

        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(recipeFetcher.currentRecipe, "Recipe should not be nil")

        if let recipe = recipeFetcher.currentRecipe {
            print("Fetched Recipe: \(recipe.name)")
            print("Body: \(recipe.description)")
            
            //Check that the title and body are not empty
            XCTAssertFalse(recipe.name.isEmpty, "Recipe title should not be empty")
            XCTAssertFalse(recipe.description.isEmpty, "Recipe body should not be empty")

            if let imageUrl = recipe.recipeImage {
                XCTAssertNotNil(URL(string: imageUrl), "Recipe image URL should be valid")
            }
        } else {
            XCTFail("Recipe fetch failed, currentRecipe is nil")
        }
    }
}
