//fetch recipe 
import Foundation

struct FetchedRecipe: Identifiable, Decodable { // represents a single recipe fetched from the server
    let id: Int
    let title: String
    let body: String
    let createdAt: String
    let time: Int
    let diets: [FetchedDiet]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case createdAt = "created_at"
        case time
        case diets
    }
}

struct FetchedDiet: Decodable { //represents the dietary information associated with a recipe
    let id: Int
    let name: String
}

//RecipeFetcher that gets recipes from the backend
class RecipeFetcher: ObservableObject {
    @Published var recipes: [FetchedRecipe] = []
    
    func fetchRecipes() async{
        print("Starting recipe fetch...")
        guard let url = URL(string: "http://127.0.0.1:8000/admin/tastebuds/allrecipe/") else {
            //i think theres something wrong with this url and thats why its not connectiong
            //maybe alyssa can u look at this idk whats wrong here
            print("Invalid URL")
            return
        }
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            let decodedRecipes = try JSONDecoder().decode([FetchedRecipe].self, from: data)
            DispatchQueue.main.async {
                self.recipes = decodedRecipes
                print("Fetched recipes count: \(self.recipes.count)") //how many recipes were fetched
                for recipe in self.recipes {
                    print("Recipe title: \(recipe.title)") //log each recipe title
                }
            }
        } catch {
            print("Error decoding recipes: \(error)")
        }
    }
}
    
